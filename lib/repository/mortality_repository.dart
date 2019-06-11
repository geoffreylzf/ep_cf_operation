import 'package:ep_cf_operation/db/dao/cf_mortality_dao.dart';
import 'package:ep_cf_operation/model/table/cf_mortality.dart';
import 'package:ep_cf_operation/model/upload_result.dart';
import 'package:ep_cf_operation/module/api_module.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:ep_cf_operation/util/date_time_util.dart';

class MortalityRepository {
  static final _instance = MortalityRepository._internal();

  MortalityRepository._internal();

  factory MortalityRepository() => _instance;

  Future<List<CfMortality>> getTodayList() async {
    final companyId = await SharedPreferencesModule().getCompanyId();
    final locationId = await SharedPreferencesModule().getLocationId();
    final currentDate = DateTimeUtil().getCurrentDate();

    return await CfMortalityDao().searchList(
      companyId: companyId,
      locationId: locationId,
      recordDate: currentDate,
    );
  }

  Future<List<CfMortality>> getSearchedList(
    int houseNo,
    String recordStartDate,
    String recordEndDate,
  ) async {
    final companyId = await SharedPreferencesModule().getCompanyId();
    final locationId = await SharedPreferencesModule().getLocationId();

    return await CfMortalityDao().searchList(
      companyId: companyId,
      locationId: locationId,
      houseNo: houseNo,
      recordStartDate: recordStartDate,
      recordEndDate: recordEndDate,
      orderBy: "record_date DESC, house_no DESC",
    );
  }

  Future<bool> saveCfMortality(CfMortality cfMortality) async {
    var list = await CfMortalityDao().searchList(
      companyId: cfMortality.companyId,
      locationId: cfMortality.locationId,
      recordDate: cfMortality.recordDate,
      houseNo: cfMortality.houseNo,
    );

    if (list.length == 0) {
      await CfMortalityDao().insert(cfMortality);
    } else {
      return false;
    }
    return true;
  }

  Future<int> getNewHouseNo(String recordDate) async {
    final companyId = await SharedPreferencesModule().getCompanyId();
    final locationId = await SharedPreferencesModule().getLocationId();

    var list = await CfMortalityDao().searchList(
      companyId: companyId,
      locationId: locationId,
      recordDate: recordDate,
    );

    if (list.length == 0) {
      return 1;
    }

    var max = 1;

    list.forEach((m) {
      if (m.houseNo > max) {
        max = m.houseNo;
      }
    });

    max++;

    return max;
  }

  Future<List<CfMortality>> getNoUpload() async {
    var list = await CfMortalityDao().searchList(
      isUpload: 0,
      isDelete: null,
    );
    return list;
  }

  Future<void> updateStatusAfterUpload(List<PairId> cfMortalityPairIdList) async {
    await Future.forEach(cfMortalityPairIdList, (pairId) async {
      final cfMortality = await CfMortalityDao().getById(pairId.id);
      cfMortality.sid = pairId.sid;
      cfMortality.isUpload = 1;
      await CfMortalityDao().update(cfMortality);
    });
  }

  Future<void> deleteById(int id) async {
    final cfMortality = await CfMortalityDao().getById(id);
    cfMortality.isDelete = 1;
    cfMortality.isUpload = 0;
    await CfMortalityDao().update(cfMortality);
  }

  Future<void> refreshHistory(int batch) async {
    final companyId = await SharedPreferencesModule().getCompanyId();
    final locationId = await SharedPreferencesModule().getLocationId();
    final apiResponse = await ApiModule().getCfMortalityList(companyId, locationId, batch);
    final cfMortalityList = apiResponse.result;

    cfMortalityList.forEach((m) {
      m.isUpload = 1;
      m.isDelete = 0;
    });

    if (batch == 1) {
      await CfMortalityDao().remove(companyId, locationId, 1);
    }

    await Future.forEach(cfMortalityList, (cfMortality) async {
      await CfMortalityDao().insert(cfMortality);
    });
  }
}

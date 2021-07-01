
import 'package:ep_cf_operation/db/dao/cf_feed_consumption_dao.dart';
import 'package:ep_cf_operation/model/table/cf_feed_consumption.dart';
import 'package:ep_cf_operation/model/upload_result.dart';
import 'package:ep_cf_operation/module/api_module.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:ep_cf_operation/util/date_time_util.dart';

class FeedConsumptionRepository {
  static final _instance = FeedConsumptionRepository._internal();

  FeedConsumptionRepository._internal();

  factory FeedConsumptionRepository() => _instance;

  Future<List<CfFeedConsumption>> getTodayList() async {
    final companyId = await SharedPreferencesModule().getCompanyId();
    final locationId = await SharedPreferencesModule().getLocationId();
    final currentDate = DateTimeUtil().getCurrentDate();

    return await CfFeedConsumptionDao().searchList(
      companyId: companyId,
      locationId: locationId,
      recordDate: currentDate,
    );
  }

  Future<List<CfFeedConsumption>> getSearchedList(
      int houseNo,
      String recordStartDate,
      String recordEndDate,
      ) async {
    final companyId = await SharedPreferencesModule().getCompanyId();
    final locationId = await SharedPreferencesModule().getLocationId();

    return await CfFeedConsumptionDao().searchList(
      companyId: companyId,
      locationId: locationId,
      houseNo: houseNo,
      recordStartDate: recordStartDate,
      recordEndDate: recordEndDate,
      orderBy: "record_date DESC, house_no DESC",
    );
  }

  Future<bool> saveCfFeedConsumption(CfFeedConsumption cfFeedConsumption) async {
    var list = await CfFeedConsumptionDao().searchList(
      companyId: cfFeedConsumption.companyId,
      locationId: cfFeedConsumption.locationId,
      recordDate: cfFeedConsumption.recordDate,
      houseNo: cfFeedConsumption.houseNo,
    );

    if (list.length == 0) {
      await CfFeedConsumptionDao().insert(cfFeedConsumption);
    } else {
      return false;
    }
    return true;
  }

  Future<int> getNewHouseNo(String recordDate) async {
    final companyId = await SharedPreferencesModule().getCompanyId();
    final locationId = await SharedPreferencesModule().getLocationId();

    var list = await CfFeedConsumptionDao().searchList(
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

  Future<List<CfFeedConsumption>> getNoUpload() async {
    return await CfFeedConsumptionDao().searchList(
      isUpload: 0,
      isDelete: null,
    );
  }

  Future<void> updateStatusAfterUpload(List<PairId> cfMortalityPairIdList) async {
    await Future.forEach(cfMortalityPairIdList, (pairId) async {
      final cfMortality = await CfFeedConsumptionDao().getById(pairId.id);
      cfMortality.sid = pairId.sid;
      cfMortality.isUpload = 1;
      await CfFeedConsumptionDao().update(cfMortality);
    });
  }

  Future<void> deleteById(int id) async {
    final cfMortality = await CfFeedConsumptionDao().getById(id);
    cfMortality.isDelete = 1;
    cfMortality.isUpload = 0;
    await CfFeedConsumptionDao().update(cfMortality);
  }

  Future<void> refreshHistory(int batch) async {
    final companyId = await SharedPreferencesModule().getCompanyId();
    final locationId = await SharedPreferencesModule().getLocationId();
    final apiResponse = await ApiModule().getCfFeedConsumptionList(companyId, locationId, batch);
    final cfFeedConsumptionList = apiResponse.result;

    cfFeedConsumptionList.forEach((m) {
      m.isUpload = 1;
      m.isDelete = 0;
    });

    if (batch == 1) {
      await CfFeedConsumptionDao().remove(companyId, locationId, 1);
    }

    await Future.forEach(cfFeedConsumptionList, (x) async {
      await CfFeedConsumptionDao().insert(x);
    });
  }
}
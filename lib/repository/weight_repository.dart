import 'package:ep_cf_operation/db/dao/cf_weight_dao.dart';
import 'package:ep_cf_operation/db/dao/cf_weight_detail_dao.dart';
import 'package:ep_cf_operation/model/table/cf_weight.dart';
import 'package:ep_cf_operation/model/table/cf_weight_detail.dart';
import 'package:ep_cf_operation/model/upload_result.dart';
import 'package:ep_cf_operation/module/api_module.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:ep_cf_operation/util/date_time_util.dart';

class WeightRepository {
  static final _instance = WeightRepository._internal();

  WeightRepository._internal();

  factory WeightRepository() => _instance;

  Future<List<CfWeight>> getTodayList() async {
    final companyId = await SharedPreferencesModule().getCompanyId();
    final locationId = await SharedPreferencesModule().getLocationId();
    final currentDate = DateTimeUtil().getCurrentDate();

    return await CfWeightDao().searchList(
      companyId: companyId,
      locationId: locationId,
      recordDate: currentDate,
    );
  }

  Future<List<CfWeight>> getNoUpload() async {
    var list = await CfWeightDao().searchList(
      isUpload: 0,
      isDelete: null,
    );

    await Future.forEach(list, (cfWeight) async {
      await cfWeight.loadDetailList();
    });

    return list;
  }

  Future<void> updateStatusAfterUpload(List<PairId> cfWeightPairIdList) async {
    await Future.forEach(cfWeightPairIdList, (pairId) async {
      final cfWeight = await CfWeightDao().getById(pairId.id);
      cfWeight.sid = pairId.sid;
      cfWeight.isUpload = 1;
      await CfWeightDao().update(cfWeight);
    });
  }

  Future<List<CfWeight>> getSearchedList(
    int houseNo,
    int day,
    String recordStartDate,
    String recordEndDate,
  ) async {
    final companyId = await SharedPreferencesModule().getCompanyId();
    final locationId = await SharedPreferencesModule().getLocationId();

    return await CfWeightDao().searchList(
      companyId: companyId,
      locationId: locationId,
      houseNo: houseNo,
      day: day,
      recordStartDate: recordStartDate,
      recordEndDate: recordEndDate,
      orderBy: "record_date DESC, house_no DESC",
    );
  }

  Future<void> deleteById(int id) async {
    final cfMortality = await CfWeightDao().getById(id);
    cfMortality.isDelete = 1;
    cfMortality.isUpload = 0;
    await CfWeightDao().update(cfMortality);
  }

  Future<void> refreshHistory(int batch) async {
    final companyId = await SharedPreferencesModule().getCompanyId();
    final locationId = await SharedPreferencesModule().getLocationId();
    final apiResponse = await ApiModule().getCfWeightList(companyId, locationId, batch);
    final cfWeightList = apiResponse.result;

    cfWeightList.forEach((m) {
      m.isUpload = 1;
      m.isDelete = 0;
    });

    if (batch == 1) {
      await CfWeightDao().remove(companyId, locationId, 1);
    }

    await Future.forEach<CfWeight>(cfWeightList, (cfWeight) async {
      final cfWeightId = await CfWeightDao().insert(cfWeight);

      await Future.forEach<CfWeightDetail>(cfWeight.cfWeightDetailList, (cfWeightDetail) async {
        cfWeightDetail.cfWeightId = cfWeightId;
        await CfWeightDetailDao().insert(cfWeightDetail);
      });
    });
  }
}

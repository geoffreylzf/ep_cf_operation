import 'package:ep_cf_operation/db/dao/cf_feed_in_dao.dart';
import 'package:ep_cf_operation/db/dao/cf_feed_in_detail_dao.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in_detail.dart';
import 'package:ep_cf_operation/model/upload_result.dart';
import 'package:ep_cf_operation/module/api_module.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:ep_cf_operation/util/date_time_util.dart';

class FeedInRepository {
  static final _instance = FeedInRepository._internal();

  FeedInRepository._internal();

  factory FeedInRepository() => _instance;

  Future<List<CfFeedIn>> getNoUpload() async {
    var list = await CfFeedInDao().searchList(
      isUpload: 0,
      isDelete: null,
    );

    await Future.forEach<CfFeedIn>(list, (cfFeedIn) async {
      await cfFeedIn.loadDetailList();
    });

    return list;
  }

  Future<void> updateStatusAfterUpload(List<PairId> cfFeedInPairIdList) async {
    await Future.forEach(cfFeedInPairIdList, (pairId) async {
      final cfFeedIn = await CfFeedInDao().getById(pairId.id);
      cfFeedIn.sid = pairId.sid;
      cfFeedIn.isUpload = 1;
      await CfFeedInDao().update(cfFeedIn);
    });
  }

  Future<List<CfFeedIn>> getTodayList() async {
    final companyId = await SharedPreferencesModule().getCompanyId();
    final locationId = await SharedPreferencesModule().getLocationId();
    final currentDate = DateTimeUtil().getCurrentDate();

    return await CfFeedInDao().searchList(
      companyId: companyId,
      locationId: locationId,
      recordDate: currentDate,
    );
  }

  Future<List<CfFeedIn>> getSearchedList(
    String recordStartDate,
    String recordEndDate,
    String docNo,
    String truckNo,
  ) async {
    final companyId = await SharedPreferencesModule().getCompanyId();
    final locationId = await SharedPreferencesModule().getLocationId();

    return await CfFeedInDao().searchList(
      companyId: companyId,
      locationId: locationId,
      recordStartDate: recordStartDate,
      recordEndDate: recordEndDate,
      docNo: docNo,
      truckNo: truckNo,
      orderBy: "record_date DESC",
    );
  }

  Future<void> deleteById(int id) async {
    final cfFeedIn = await CfFeedInDao().getById(id);
    cfFeedIn
      ..isDelete = 1
      ..isUpload = 0;
    await CfFeedInDao().update(cfFeedIn);
  }

  Future<void> refreshHistory(int batch) async {
    final companyId = await SharedPreferencesModule().getCompanyId();
    final locationId = await SharedPreferencesModule().getLocationId();
    final apiResponse = await ApiModule().getCfFeedInList(companyId, locationId, batch);
    final cfFeedInList = apiResponse.result;

    cfFeedInList.forEach((m) {
      m.isUpload = 1;
      m.isDelete = 0;
    });

    if (batch == 1) {
      await CfFeedInDao().remove(companyId, locationId, 1);
    }

    await Future.forEach<CfFeedIn>(cfFeedInList, (cfFeedIn) async {
      final cfFeedInId = await CfFeedInDao().insert(cfFeedIn);

      await Future.forEach<CfFeedInDetail>(cfFeedIn.cfFeedInDetailList, (cfFeedInDetail) async {
        cfFeedInDetail.cfFeedInId = cfFeedInId;
        await CfFeedInDetailDao().insert(cfFeedInDetail);
      });
    });
  }
}

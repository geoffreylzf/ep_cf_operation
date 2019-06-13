import 'package:ep_cf_operation/model/table/base_model.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in_detail.dart';
import 'package:ep_cf_operation/util/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CfFeedIn extends BaseModel {
  int id, sid, companyId, locationId, docId;
  String recordDate, docNo, truckNo, uuid, timestamp;
  double variance;
  List<CfFeedInDetail> cfFeedInDetailList;

  CfFeedIn({
    this.id,
    this.sid,
    this.companyId,
    this.locationId,
    this.docId,
    this.docNo,
    this.recordDate,
    this.truckNo,
    this.variance,
    this.uuid,
    isDelete,
    isUpload,
    this.timestamp,
    this.cfFeedInDetailList,
  }) : super(isUpload: isUpload, isDelete: isDelete);

  CfFeedIn.db({
    @required this.companyId,
    @required this.locationId,
    @required this.docId,
    @required this.docNo,
    @required this.recordDate,
    @required this.truckNo,
    @required this.variance,
  }) {
    uuid = Uuid().v1();
    timestamp = DateTimeUtil().getCurrentTimestamp();
  }

  factory CfFeedIn.fromJson(Map<String, dynamic> json) => CfFeedIn(
        id: json["id"],
        sid: json["sid"],
        companyId: json["company_id"],
        locationId: json["location_id"],
        docId: json["doc_id"],
        docNo: json["doc_no"],
        recordDate: json["record_date"],
        truckNo: json["truck_no"],
        variance: json["variance"] is int ? (json["variance"] as int).toDouble() : json["variance"],
        uuid: json["uuid"],
        isUpload: json["is_upload"],
        isDelete: json["is_delete"],
        timestamp: json["timestamp"],
        cfFeedInDetailList: json["cf_feed_in_detail_list"] != null
            ? List<CfFeedInDetail>.from(
                json["cf_feed_in_detail_list"].map((dt) => CfFeedInDetail.fromJson(dt)))
            : [],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sid": sid,
    "company_id": companyId,
    "location_id": locationId,
    "doc_id": docId,
    "doc_no": docNo,
    "record_date": recordDate,
    "truck_no": truckNo,
    "variance" : variance,
    "uuid": uuid,
    "is_upload": isUpload,
    "is_delete": isDelete,
    "timestamp": timestamp,
    "cf_feed_in_detail_list": cfFeedInDetailList != null && cfFeedInDetailList.length > 0
        ? List<dynamic>.from(cfFeedInDetailList.map((x) => x.toJson()))
        : [],
  };

  Map<String, dynamic> toDbJson() {
    return toJson()..remove("cf_feed_in_detail_list");
  }
}

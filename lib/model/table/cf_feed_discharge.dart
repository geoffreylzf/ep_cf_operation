import 'package:ep_cf_operation/model/table/base_model.dart';
import 'package:ep_cf_operation/model/table/cf_feed_discharge_detail.dart';
import 'package:ep_cf_operation/util/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CfFeedDischarge extends BaseModel {
  int id, sid, companyId, locationId;
  String recordDate, dischargeCode, truckNo, uuid, timestamp;
  List<CfFeedDischargeDetail> cfFeedDischargeDetailList;

  CfFeedDischarge({
    this.id,
    this.sid,
    this.companyId,
    this.locationId,
    this.recordDate,
    this.dischargeCode,
    this.truckNo,
    this.uuid,
    isDelete,
    isUpload,
    this.timestamp,
    this.cfFeedDischargeDetailList
  }) : super(isUpload: isUpload, isDelete: isDelete);

  CfFeedDischarge.db({
    @required this.companyId,
    @required this.locationId,
    @required this.recordDate,
    @required this.dischargeCode,
    @required this.truckNo,
  }) {
    uuid = Uuid().v1();
    timestamp = DateTimeUtil().getCurrentTimestamp();
  }

  factory CfFeedDischarge.fromJson(Map<String, dynamic> json) => CfFeedDischarge(
    id: json["id"],
    sid: json["sid"],
    companyId: json["company_id"],
    locationId: json["location_id"],
    recordDate: json["record_date"],
    dischargeCode: json["discharge_code"],
    truckNo: json["truck_no"],
    uuid: json["uuid"],
    isUpload: json["is_upload"],
    isDelete: json["is_delete"],
    timestamp: json["timestamp"],
    cfFeedDischargeDetailList: json["cf_feed_discharge_detail_list"] != null
        ? List<CfFeedDischargeDetail>.from(
        json["cf_feed_discharge_detail_list"].map((dt) => CfFeedDischargeDetail.fromJson(dt)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sid": sid,
    "company_id": companyId,
    "location_id": locationId,
    "record_date": recordDate,
    "discharge_code": dischargeCode,
    "truck_no": truckNo,
    "uuid": uuid,
    "is_upload": isUpload,
    "is_delete": isDelete,
    "timestamp": timestamp,
    "cf_feed_discharge_detail_list": cfFeedDischargeDetailList != null && cfFeedDischargeDetailList.length > 0
        ? List<dynamic>.from(cfFeedDischargeDetailList.map((x) => x.toJson()))
        : [],
  };

  Map<String, dynamic> toDbJson() {
    return toJson()..remove("cf_feed_discharge_detail_list");
  }
}

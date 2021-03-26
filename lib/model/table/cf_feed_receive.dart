import 'package:ep_cf_operation/model/table/base_model.dart';
import 'package:ep_cf_operation/util/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'cf_feed_receive_detail.dart';

class CfFeedReceive extends BaseModel {
  int id, sid, companyId, locationId;
  String recordDate, dischargeCode, truckNo, uuid, timestamp;
  double variance;
  List<CfFeedReceiveDetail> cfFeedReceiveDetailList;

  CfFeedReceive({
    this.id,
    this.sid,
    this.companyId,
    this.locationId,
    this.recordDate,
    this.dischargeCode,
    this.truckNo,
    this.variance,
    this.uuid,
    isDelete,
    isUpload,
    this.timestamp,
    this.cfFeedReceiveDetailList,
  }) : super(isUpload: isUpload, isDelete: isDelete);

  CfFeedReceive.db({
    @required this.companyId,
    @required this.locationId,
    @required this.recordDate,
    @required this.dischargeCode,
    @required this.truckNo,
    @required this.variance,
  }) {
    uuid = Uuid().v1();
    timestamp = DateTimeUtil().getCurrentTimestamp();
  }

  factory CfFeedReceive.fromJson(Map<String, dynamic> json) => CfFeedReceive(
        id: json["id"],
        sid: json["sid"],
        companyId: json["company_id"],
        locationId: json["location_id"],
        recordDate: json["record_date"],
        dischargeCode: json["discharge_date"],
        truckNo: json["truck_no"],
        variance: json["variance"] is int ? (json["variance"] as int).toDouble() : json["variance"],
        uuid: json["uuid"],
        isUpload: json["is_upload"],
        isDelete: json["is_delete"],
        timestamp: json["timestamp"],
        cfFeedReceiveDetailList: json["cf_feed_receive_detail_list"] != null
            ? List<CfFeedReceiveDetail>.from(
                json["cf_feed_receive_detail_list"].map((dt) => CfFeedReceiveDetail.fromJson(dt)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sid": sid,
        "company_id": companyId,
        "location_id": locationId,
        "record_date": recordDate,
        "discharge_date": dischargeCode,
        "truck_no": truckNo,
        "variance": variance,
        "uuid": uuid,
        "is_upload": isUpload,
        "is_delete": isDelete,
        "timestamp": timestamp,
        "cf_feed_receive_detail_list":
            cfFeedReceiveDetailList != null && cfFeedReceiveDetailList.length > 0
                ? List<dynamic>.from(cfFeedReceiveDetailList.map((x) => x.toJson()))
                : [],
      };

  Map<String, dynamic> toDbJson() {
    return toJson()..remove("cf_feed_in_detail_list");
  }
}

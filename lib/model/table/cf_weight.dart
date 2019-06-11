import 'package:ep_cf_operation/db/dao/cf_weight_detail_dao.dart';
import 'package:ep_cf_operation/model/table/base_model.dart';
import 'package:ep_cf_operation/model/table/cf_weight_detail.dart';
import 'package:ep_cf_operation/util/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CfWeight extends BaseModel {
  int id, sid, companyId, locationId, houseNo, day;
  String recordDate, recordTime, uuid, timestamp;
  List<CfWeightDetail> cfWeightDetailList;

  CfWeight({
    this.id,
    this.sid,
    this.companyId,
    this.locationId,
    this.houseNo,
    this.day,
    this.recordDate,
    this.recordTime,
    this.uuid,
    isDelete,
    isUpload,
    this.timestamp,
    this.cfWeightDetailList,
  }) : super(
          isUpload: isUpload,
          isDelete: isDelete,
        );

  CfWeight.db({
    @required this.companyId,
    @required this.locationId,
    @required this.houseNo,
    @required this.day,
    @required this.recordDate,
    @required this.recordTime,
  }) {
    uuid = Uuid().v1();
    timestamp = DateTimeUtil().getCurrentTimestamp();
  }

  factory CfWeight.fromJson(Map<String, dynamic> json) => CfWeight(
        id: json["id"],
        sid: json["sid"],
        companyId: json["company_id"],
        locationId: json["location_id"],
        houseNo: json["house_no"],
        day: json["day"],
        recordDate: json["record_date"],
        recordTime: json["record_time"],
        uuid: json["uuid"],
        isUpload: json["is_upload"],
        isDelete: json["is_delete"],
        timestamp: json["timestamp"],
        cfWeightDetailList: json["cf_weight_detail_list"] != null
            ? List<CfWeightDetail>.from(
                json["cf_weight_detail_list"].map((dt) => CfWeightDetail.fromJson(dt)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sid": sid,
        "company_id": companyId,
        "location_id": locationId,
        "house_no": houseNo,
        "day": day,
        "record_date": recordDate,
        "record_time": recordTime,
        "uuid": uuid,
        "is_upload": isUpload,
        "is_delete": isDelete,
        "timestamp": timestamp,
        "cf_weight_detail_list": cfWeightDetailList != null && cfWeightDetailList.length > 0
            ? List<dynamic>.from(cfWeightDetailList.map((x) => x.toJson()))
            : [],
      };

  Map<String, dynamic> toDbJson() {
    return toJson()..remove("cf_weight_detail_list");
  }

  loadDetailList() async {
    cfWeightDetailList = await CfWeightDetailDao().getListByCfWeightId(id);
  }
}

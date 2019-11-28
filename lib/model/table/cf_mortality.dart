import 'package:ep_cf_operation/model/table/base_model.dart';
import 'package:ep_cf_operation/util/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CfMortality extends BaseModel {
  int id, sid, companyId, locationId, houseNo, mQty, rQty;
  String recordDate, remark, uuid, timestamp;

  CfMortality({
    this.id,
    this.sid,
    this.companyId,
    this.locationId,
    this.recordDate,
    this.houseNo,
    this.mQty,
    this.rQty,
    this.remark,
    this.uuid,
    isDelete,
    isUpload,
    this.timestamp,
  }) : super(
          isUpload: isUpload,
          isDelete: isDelete,
        );

  CfMortality.db({
    @required this.companyId,
    @required this.locationId,
    @required this.recordDate,
    @required this.houseNo,
    @required this.mQty,
    @required this.rQty,
    @required this.remark,
  }) {
    uuid = Uuid().v1();
    timestamp = DateTimeUtil().getCurrentTimestamp();
  }

  factory CfMortality.fromJson(Map<String, dynamic> json) => CfMortality(
        id: json["id"],
        sid: json["sid"],
        companyId: json["company_id"],
        locationId: json["location_id"],
        houseNo: json["house_no"],
        recordDate: json["record_date"],
        mQty: json["m_qty"],
        rQty: json["r_qty"],
        remark: json["remark"],
        uuid: json["uuid"],
        isUpload: json["is_upload"],
        isDelete: json["is_delete"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sid": sid,
        "company_id": companyId,
        "location_id": locationId,
        "house_no": houseNo,
        "record_date": recordDate,
        "m_qty": mQty,
        "r_qty": rQty,
        "remark": remark,
        "uuid": uuid,
        "is_upload": isUpload,
        "is_delete": isDelete,
        "timestamp": timestamp,
      };
}

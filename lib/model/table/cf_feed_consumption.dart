import 'package:ep_cf_operation/model/table/base_model.dart';
import 'package:ep_cf_operation/util/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CfFeedConsumption extends BaseModel {
  int id, sid, companyId, locationId, houseNo;
  double weight;
  String recordDate, itemTypeCode, uuid, timestamp;

  CfFeedConsumption({
    this.id,
    this.sid,
    this.companyId,
    this.locationId,
    this.recordDate,
    this.houseNo,
    this.itemTypeCode,
    this.weight,
    isDelete,
    isUpload,
    this.uuid,
    this.timestamp,
  }) : super(
          isUpload: isUpload,
          isDelete: isDelete,
        );

  CfFeedConsumption.db({
    @required this.companyId,
    @required this.locationId,
    @required this.recordDate,
    @required this.houseNo,
    @required this.itemTypeCode,
    @required this.weight,
  }) {
    uuid = Uuid().v1();
    timestamp = DateTimeUtil().getCurrentTimestamp();
  }

  factory CfFeedConsumption.fromJson(Map<String, dynamic> json) => CfFeedConsumption(
        id: json["id"],
        sid: json["sid"],
        companyId: json["company_id"],
        locationId: json["location_id"],
        houseNo: json["house_no"],
        recordDate: json["record_date"],
        itemTypeCode: json["item_type_code"],
        weight: json["weight"] is int ? (json["weight"] as int).toDouble() : json["weight"],
        isUpload: json["is_upload"],
        isDelete: json["is_delete"],
        uuid: json["uuid"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sid": sid,
        "company_id": companyId,
        "location_id": locationId,
        "house_no": houseNo,
        "record_date": recordDate,
        "item_type_code": itemTypeCode,
        "weight": weight,
        "uuid": uuid,
        "is_upload": isUpload,
        "is_delete": isDelete,
        "timestamp": timestamp,
      };

  String getItemTypeCodeName() {
    final itc = itemTypeCodeList.firstWhere(
      (e) => e.value == itemTypeCode,
      orElse: () => null,
    );

    if (itc != null) {
      return itc.name;
    }
    return "";
  }

  double getBag() {
    return weight / 50;
  }
}

class ItemTypeCode {
  final String name;
  final String value;

  ItemTypeCode({this.name, this.value});
}

final itemTypeCodeList = [
  ItemTypeCode(name: "Starter", value: "BFSF"),
  ItemTypeCode(name: "Grower", value: "BFGF"),
];

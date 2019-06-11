import 'package:ep_cf_operation/model/table/temp_cf_weight_detail.dart';
import 'package:flutter/material.dart';

class CfWeightDetail {
  int id, cfWeightId, section, weight, qty;
  String gender;

  CfWeightDetail({
    this.id,
    this.cfWeightId,
    this.section,
    this.weight,
    this.qty,
    this.gender,
  });

  CfWeightDetail.db({
    @required this.cfWeightId,
    @required this.section,
    @required this.weight,
    @required this.qty,
    @required this.gender,
  });

  factory CfWeightDetail.fromJson(Map<String, dynamic> json) => CfWeightDetail(
        id: json["id"],
        cfWeightId: json["cf_weight_id"],
        section: json["section"],
        weight: json["weight"],
        qty: json["qty"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cf_weight_id": cfWeightId,
        "section": section,
        "weight": weight,
        "qty": qty,
        "gender": gender,
      };

  static List<CfWeightDetail> fromTempWithCfWeightId(
      int cfWeightId, List<TempCfWeightDetail> tempList) {
    final List<CfWeightDetail> detailList = [];

    tempList.forEach((temp) {
      detailList.add(CfWeightDetail.db(
        cfWeightId: cfWeightId,
        section: temp.section,
        weight: temp.weight,
        gender: temp.gender,
        qty: temp.qty,
      ));
    });

    return detailList;
  }
}

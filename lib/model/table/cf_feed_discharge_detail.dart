import 'package:ep_cf_operation/model/table/temp_cf_feed_discharge_detail.dart';
import 'package:flutter/material.dart';

class CfFeedDischargeDetail {
  int id, cfFeedDischargeId, houseNo, itemPackingId;
  double weight;

  CfFeedDischargeDetail({
    this.id,
    this.cfFeedDischargeId,
    this.houseNo,
    this.itemPackingId,
    this.weight,
  });

  CfFeedDischargeDetail.db({
    @required this.cfFeedDischargeId,
    @required this.houseNo,
    @required this.itemPackingId,
    @required this.weight,
  });

  factory CfFeedDischargeDetail.fromJson(Map<String, dynamic> json) => CfFeedDischargeDetail(
        id: json["id"],
        cfFeedDischargeId: json["cf_feed_discharge_id"],
        houseNo: json["house_no"],
        itemPackingId: json["item_packing_id"],
        weight: json["weight"] is int ? (json["weight"] as int).toDouble() : json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cf_feed_discharge_id": cfFeedDischargeId,
        "house_no": houseNo,
        "item_packing_id": itemPackingId,
        "weight": weight,
      };

  static List<CfFeedDischargeDetail> fromTempWithCfFeedDischargeId(
      int cfFeedDischargeId, List<TempCfFeedDischargeDetail> tempList) {
    final List<CfFeedDischargeDetail> detailList = [];

    tempList.forEach((temp) {
      detailList.add(CfFeedDischargeDetail.db(
        cfFeedDischargeId: cfFeedDischargeId,
        houseNo: temp.houseNo,
        itemPackingId: temp.itemPackingId,
        weight: temp.weight,
      ));
    });

    return detailList;
  }
}

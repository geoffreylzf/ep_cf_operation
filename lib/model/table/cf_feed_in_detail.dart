import 'package:ep_cf_operation/model/table/temp_cf_feed_in_detail.dart';
import 'package:flutter/material.dart';

class CfFeedInDetail {
  int id, cfFeedInId, docDetailId, houseNo, itemPackingId;
  String compartmentNo;
  double qty, weight;

  CfFeedInDetail({
    this.id,
    this.cfFeedInId,
    this.docDetailId,
    this.houseNo,
    this.itemPackingId,
    this.compartmentNo,
    this.qty,
    this.weight,
  });

  CfFeedInDetail.db({
    @required this.cfFeedInId,
    @required this.docDetailId,
    @required this.houseNo,
    @required this.itemPackingId,
    @required this.compartmentNo,
    @required this.qty,
    @required this.weight,
  });

  factory CfFeedInDetail.fromJson(Map<String, dynamic> json) => CfFeedInDetail(
        id: json["id"],
        cfFeedInId: json["cf_feed_in_id"],
        docDetailId: json["doc_detail_id"],
        houseNo: json["house_no"],
        itemPackingId: json["item_packing_id"],
        compartmentNo: json["compartment_no"],
        qty: json["qty"] is int ? (json["qty"] as int).toDouble() : json["qty"],
        weight: json["weight"] is int ? (json["weight"] as int).toDouble() : json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cf_feed_in_id": cfFeedInId,
        "doc_detail_id": docDetailId,
        "house_no": houseNo,
        "item_packing_id": itemPackingId,
        "compartment_no": compartmentNo,
        "qty": qty,
        "weight": weight,
      };

  static List<CfFeedInDetail> fromTempWithCfFeedInId(
      int cfFeedInId, List<TempCfFeedInDetail> tempList) {
    final List<CfFeedInDetail> detailList = [];

    tempList.forEach((temp) {
      detailList.add(CfFeedInDetail.db(
        cfFeedInId: cfFeedInId,
        docDetailId: temp.docDetailId,
        houseNo: temp.houseNo,
        itemPackingId: temp.itemPackingId,
        compartmentNo: temp.compartmentNo,
        qty: temp.qty,
        weight: temp.weight,
      ));
    });

    return detailList;
  }
}

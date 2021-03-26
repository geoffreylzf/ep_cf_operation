import 'package:ep_cf_operation/model/table/temp_cf_feed_receive_detail.dart';
import 'package:flutter/material.dart';

class CfFeedReceiveDetail {
  int id, cfFeedReceiveId, houseNo, itemPackingId;
  double weight;

  CfFeedReceiveDetail({
    this.id,
    this.cfFeedReceiveId,
    this.houseNo,
    this.itemPackingId,
    this.weight,
  });

  CfFeedReceiveDetail.db({
    @required this.cfFeedReceiveId,
    @required this.houseNo,
    @required this.itemPackingId,
    @required this.weight,
  });

  factory CfFeedReceiveDetail.fromJson(Map<String, dynamic> json) => CfFeedReceiveDetail(
        id: json["id"],
        cfFeedReceiveId: json["cf_feed_receive_id"],
        houseNo: json["house_no"],
        itemPackingId: json["item_packing_id"],
        weight: json["weight"] is int ? (json["weight"] as int).toDouble() : json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cf_feed_receive_id": cfFeedReceiveId,
        "house_no": houseNo,
        "item_packing_id": itemPackingId,
        "weight": weight,
      };

  static List<CfFeedReceiveDetail> fromTempWithCfFeedReceiveId(
      int cfFeedReceiveId, List<TempCfFeedReceiveDetail> tempList) {
    final List<CfFeedReceiveDetail> detailList = [];

    tempList.forEach((temp) {
      detailList.add(CfFeedReceiveDetail.db(
        cfFeedReceiveId: cfFeedReceiveId,
        houseNo: temp.houseNo,
        itemPackingId: temp.itemPackingId,
        weight: temp.weight,
      ));
    });

    return detailList;
  }
}

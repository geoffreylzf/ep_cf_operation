class TempCfFeedReceiveDetail {
  int id, houseNo, itemPackingId;
  double weight;

  TempCfFeedReceiveDetail({
    this.id,
    this.houseNo,
    this.itemPackingId,
    this.weight,
  });

  factory TempCfFeedReceiveDetail.fromJson(Map<String, dynamic> json) => TempCfFeedReceiveDetail(
        id: json["id"],
        houseNo: json["house_no"],
        itemPackingId: json["item_packing_id"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "house_no": houseNo,
        "item_packing_id": itemPackingId,
        "weight": weight,
      };
}

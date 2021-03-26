class TempCfFeedDischargeDetail {
  int id, houseNo, itemPackingId;
  double weight;

  TempCfFeedDischargeDetail({
    this.id,
    this.houseNo,
    this.itemPackingId,
    this.weight,
  });

  factory TempCfFeedDischargeDetail.fromJson(Map<String, dynamic> json) =>
      TempCfFeedDischargeDetail(
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

class TempCfFeedInDetail {
  int id, docDetailId, houseNo, itemPackingId;
  String compartmentNo;
  double qty, weight;

  TempCfFeedInDetail({
    this.id,
    this.docDetailId,
    this.houseNo,
    this.itemPackingId,
    this.compartmentNo,
    this.qty,
    this.weight,
  });

  factory TempCfFeedInDetail.fromJson(Map<String, dynamic> json) => TempCfFeedInDetail(
        id: json["id"],
        docDetailId: json["doc_detail_id"],
        houseNo: json["house_no"],
        itemPackingId: json["item_packing_id"],
        compartmentNo: json["compartment_no"],
        qty: json["qty"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "doc_detail_id": docDetailId,
        "house_no": houseNo,
        "item_packing_id": itemPackingId,
        "compartment_no": compartmentNo,
        "qty": qty,
        "weight": weight,
      };
}

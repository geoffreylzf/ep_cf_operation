class TempCfWeightDetail {
  int id, section, weight, qty;
  String gender;

  TempCfWeightDetail({
    this.id,
    this.section,
    this.weight,
    this.qty,
    this.gender,
  });

  factory TempCfWeightDetail.fromJson(Map<String, dynamic> json) => TempCfWeightDetail(
        id: json["id"],
        section: json["section"],
        weight: json["weight"],
        qty: json["qty"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "section": section,
        "weight": weight,
        "qty": qty,
        "gender": gender,
      };
}

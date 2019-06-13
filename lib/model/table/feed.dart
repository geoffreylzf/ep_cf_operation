class Feed {
  int id;
  String skuCode, skuName;

  Feed({
    this.id,
    this.skuCode,
    this.skuName,
  });

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
    id: json["id"],
    skuCode: json["sku_code"],
    skuName: json["sku_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sku_code": skuCode,
    "sku_name": skuName,
  };
}

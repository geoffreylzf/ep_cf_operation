import 'package:ep_cf_operation/db/db.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in_detail.dart';

const _table = "cf_feed_in_detail";

class CfFeedInDetailDao {
  static final _instance = CfFeedInDetailDao._internal();

  CfFeedInDetailDao._internal();

  factory CfFeedInDetailDao() => _instance;

  Future<int> insert(CfFeedInDetail cfFeedInDetail) async {
    final db = await Db().database;
    return await db.insert(_table, cfFeedInDetail.toJson());
  }

  Future<List<CfFeedInDetailWithInfo>> getListByCfFeedInId(int cfFeedInId) async {
    final db = await Db().database;

    final res = await db.rawQuery("""
    SELECT 
      cf_feed_in_detail.*,
      feed.sku_code,
      feed.sku_name
    FROM cf_feed_in_detail
    LEFT JOIN feed ON cf_feed_in_detail.item_packing_id = feed.id
    WHERE cf_feed_in_detail.cf_feed_in_id = $cfFeedInId
    ORDER BY cf_feed_in_detail.id DESC
    """);
    return res.isNotEmpty ? res.map((c) => CfFeedInDetailWithInfo.fromJson(c)).toList() : [];
  }

  Future<void> removeByCfFeedInId(int cfFeedInId) async {
    final db = await Db().database;
    db.delete(
      _table,
      where: "cf_feed_in_id = ?",
      whereArgs: [cfFeedInId],
    );
  }
}

class CfFeedInDetailWithInfo extends CfFeedInDetail {
  String skuCode, skuName;

  CfFeedInDetailWithInfo({
    id,
    cfFeedInId,
    docDetailId,
    houseNo,
    itemPackingId,
    compartmentNo,
    qty,
    weight,
    this.skuCode,
    this.skuName,
  }) : super(
          id: id,
          cfFeedInId: cfFeedInId,
          docDetailId: docDetailId,
          houseNo: houseNo,
          itemPackingId: itemPackingId,
          compartmentNo: compartmentNo,
          qty: qty,
          weight: weight,
        );

  factory CfFeedInDetailWithInfo.fromJson(Map<String, dynamic> json) => CfFeedInDetailWithInfo(
        id: json["id"],
        cfFeedInId: json["cf_feed_in_id"],
        docDetailId: json["doc_detail_id"],
        houseNo: json["house_no"],
        itemPackingId: json["item_packing_id"],
        compartmentNo: json["compartment_no"],
        qty: json["qty"] is int ? (json["qty"] as int).toDouble() : json["qty"],
        weight: json["weight"] is int ? (json["weight"] as int).toDouble() : json["weight"],
        skuCode: json["sku_code"],
        skuName: json["sku_name"],
      );
}

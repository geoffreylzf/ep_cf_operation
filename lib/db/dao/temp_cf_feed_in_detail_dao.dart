import 'package:ep_cf_operation/db/db.dart';
import 'package:ep_cf_operation/model/table/temp_cf_feed_in_detail.dart';

const _table = "temp_cf_feed_in_detail";

class TempCfFeedInDetailDao {
  static final _instance = TempCfFeedInDetailDao._internal();

  TempCfFeedInDetailDao._internal();

  factory TempCfFeedInDetailDao() => _instance;

  Future<int> insert(TempCfFeedInDetail tempCfFeedInDetail) async {
    final db = await Db().database;
    return await db.insert(_table, tempCfFeedInDetail.toJson());
  }

  Future<int> deleteById(int id) async {
    final db = await Db().database;
    return await db.delete(_table, where: "id = ?", whereArgs: [id]);
  }

  Future<int> removeAll() async {
    final db = await Db().database;
    return await db.delete(_table);
  }

  Future<List<TempCfFeedInDetailWithInfo>> getList() async {
    final db = await Db().database;
    final res = await db.rawQuery("""
    SELECT 
      temp_cf_feed_in_detail.*,
      feed.sku_code,
      feed.sku_name
    FROM temp_cf_feed_in_detail
    LEFT JOIN feed ON temp_cf_feed_in_detail.item_packing_id = feed.id
    ORDER BY temp_cf_feed_in_detail.id DESC
    """);
    return res.isNotEmpty ? res.map((c) => TempCfFeedInDetailWithInfo.fromJson(c)).toList() : [];
  }

  Future<List<TempCfFeedInDetail>> searchList({
    int docDetailId,
    int itemPackingId,
    String compartmentNo,
    String orderBy,
  }) async {
    final db = await Db().database;
    var whereSql = "1 = 1 ";
    final whereArgs = [];

    if (docDetailId != null) {
      whereSql += "AND doc_detail_id = ? ";
      whereArgs.add(docDetailId);
    }

    if (itemPackingId != null) {
      whereSql += "AND item_packing_id = ? ";
      whereArgs.add(itemPackingId);
    }

    if (compartmentNo != null) {
      whereSql += "AND compartment_no = ? ";
      whereArgs.add(compartmentNo);
    }

    final res = await db.query(
      _table,
      where: whereSql,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );

    return res.isNotEmpty ? res.map((c) => TempCfFeedInDetail.fromJson(c)).toList() : [];
  }
}

class TempCfFeedInDetailWithInfo extends TempCfFeedInDetail {
  String skuCode, skuName;

  TempCfFeedInDetailWithInfo({
    id,
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
          docDetailId: docDetailId,
          houseNo: houseNo,
          itemPackingId: itemPackingId,
          compartmentNo: compartmentNo,
          qty: qty,
          weight: weight,
        );

  factory TempCfFeedInDetailWithInfo.fromJson(Map<String, dynamic> json) =>
      TempCfFeedInDetailWithInfo(
        id: json["id"],
        docDetailId: json["doc_detail_id"],
        houseNo: json["house_no"],
        itemPackingId: json["item_packing_id"],
        compartmentNo: json["compartment_no"],
        qty: json["qty"],
        weight: json["weight"],
        skuCode: json["sku_code"],
        skuName: json["sku_name"],
      );
}

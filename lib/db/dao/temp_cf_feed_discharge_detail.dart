import 'package:ep_cf_operation/db/db.dart';
import 'package:ep_cf_operation/model/table/temp_cf_feed_discharge_detail.dart';

const _table = "temp_cf_feed_discharge_detail";

class TempCfFeedDischargeDetailDao {
  static final _instance = TempCfFeedDischargeDetailDao._internal();

  TempCfFeedDischargeDetailDao._internal();

  factory TempCfFeedDischargeDetailDao() => _instance;

  Future<int> insert(TempCfFeedDischargeDetail tempCfFeedDischargeDetail) async {
    final db = await Db().database;
    return await db.insert(_table, tempCfFeedDischargeDetail.toJson());
  }

  Future<int> deleteById(int id) async {
    final db = await Db().database;
    return await db.delete(_table, where: "id = ?", whereArgs: [id]);
  }

  Future<int> removeAll() async {
    final db = await Db().database;
    return await db.delete(_table);
  }

  Future<List<TempCfFeedDischargeDetailWithInfo>> getList() async {
    final db = await Db().database;
    final res = await db.rawQuery("""
    SELECT 
      temp_cf_feed_discharge_detail.*,
      feed.sku_code,
      feed.sku_name
    FROM temp_cf_feed_discharge_detail
    LEFT JOIN feed ON temp_cf_feed_discharge_detail.item_packing_id = feed.id
    ORDER BY temp_cf_feed_discharge_detail.id DESC
    """);
    return res.isNotEmpty
        ? res.map((c) => TempCfFeedDischargeDetailWithInfo.fromJson(c)).toList()
        : [];
  }
}

class TempCfFeedDischargeDetailWithInfo extends TempCfFeedDischargeDetail {
  String skuCode, skuName;

  TempCfFeedDischargeDetailWithInfo({
    id,
    houseNo,
    itemPackingId,
    weight,
    this.skuCode,
    this.skuName,
  }) : super(
          id: id,
          houseNo: houseNo,
          itemPackingId: itemPackingId,
          weight: weight,
        );

  factory TempCfFeedDischargeDetailWithInfo.fromJson(Map<String, dynamic> json) =>
      TempCfFeedDischargeDetailWithInfo(
        id: json["id"],
        houseNo: json["house_no"],
        itemPackingId: json["item_packing_id"],
        weight: json["weight"],
        skuCode: json["sku_code"],
        skuName: json["sku_name"],
      );
}

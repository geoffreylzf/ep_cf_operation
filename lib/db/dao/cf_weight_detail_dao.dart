import 'package:ep_cf_operation/db/db.dart';
import 'package:ep_cf_operation/model/table/cf_weight_detail.dart';

const _table = "cf_weight_detail";

class CfWeightDetailDao {
  static final _instance = CfWeightDetailDao._internal();

  CfWeightDetailDao._internal();

  factory CfWeightDetailDao() => _instance;

  Future<int> insert(CfWeightDetail cfWeightDetail) async {
    final db = await Db().database;
    return await db.insert(_table, cfWeightDetail.toJson());
  }

  Future<List<CfWeightDetail>> getListByCfWeightId(int cfWeightId) async {
    final db = await Db().database;
    final res = await db.query(
      _table,
      where: "cf_weight_id = ?",
      whereArgs: [cfWeightId],
      orderBy: "id DESC",
    );
    return res.isNotEmpty ? res.map((c) => CfWeightDetail.fromJson(c)).toList() : [];
  }

  Future<void> removeByCfWeightId(int cfWeightId) async {
    final db = await Db().database;
    db.delete(
      _table,
      where: "cf_weight_id = ?",
      whereArgs: [cfWeightId],
    );
  }
}

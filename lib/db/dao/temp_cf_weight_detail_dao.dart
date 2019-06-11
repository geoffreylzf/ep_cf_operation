import 'package:ep_cf_operation/db/db.dart';
import 'package:ep_cf_operation/model/table/temp_cf_weight_detail.dart';

const _table = "temp_cf_weight_detail";

class TempCfWeightDetailDao {
  static final _instance = TempCfWeightDetailDao._internal();

  TempCfWeightDetailDao._internal();

  factory TempCfWeightDetailDao() => _instance;

  Future<int> insert(TempCfWeightDetail tempCfWeightDetail) async {
    final db = await Db().database;
    return await db.insert(_table, tempCfWeightDetail.toJson());
  }

  Future<List<TempCfWeightDetail>> getAll() async {
    final db = await Db().database;
    final res = await db.query(_table);
    return res.isNotEmpty ? res.map((c) => TempCfWeightDetail.fromJson(c)).toList() : [];
  }

  Future<int> deleteById(int id) async {
    var db = await Db().database;
    return await db.delete(_table, where: "id = ?", whereArgs: [id]);
  }

  Future<int> removeAll() async {
    final db = await Db().database;
    return await db.delete(_table);
  }

  Future<List<TempCfWeightDetail>> getList() async {
    final db = await Db().database;
    final res = await db.query(_table, orderBy: "id desc");
    return res.isNotEmpty
        ? res.map((c) => TempCfWeightDetail.fromJson(c)).toList()
        : [];
  }

  Future<int> deleteAll() async {
    var db = await Db().database;
    return await db.delete(_table);
  }
}

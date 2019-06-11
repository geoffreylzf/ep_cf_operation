import 'package:ep_cf_operation/db/dao/cf_weight_detail_dao.dart';
import 'package:ep_cf_operation/db/db.dart';
import 'package:ep_cf_operation/model/table/cf_weight.dart';

const _table = "cf_weight";

class CfWeightDao {
  static final _instance = CfWeightDao._internal();

  CfWeightDao._internal();

  factory CfWeightDao() => _instance;

  Future<int> insert(CfWeight cfWeight) async {
    final db = await Db().database;
    return await db.insert(_table, cfWeight.toDbJson());
  }

  Future<List<CfWeight>> searchList({
    int companyId,
    int locationId,
    String recordDate,
    String recordStartDate,
    String recordEndDate,
    int houseNo,
    int day,
    int isUpload,
    int isDelete = 0,
    String orderBy,
  }) async {
    final db = await Db().database;

    var whereSql = "1 = 1 ";
    final whereArgs = [];
    if (companyId != null) {
      whereSql += "AND company_id = ? ";
      whereArgs.add(companyId);
    }
    if (locationId != null) {
      whereSql += "AND location_id = ? ";
      whereArgs.add(locationId);
    }
    if (recordDate != null && recordDate != "") {
      whereSql += "AND record_date = ? ";
      whereArgs.add(recordDate);
    }
    if (recordStartDate != null && recordStartDate != "") {
      whereSql += "AND record_date >= ? ";
      whereArgs.add(recordStartDate);
    }
    if (recordEndDate != null && recordEndDate != "") {
      whereSql += "AND record_date <= ? ";
      whereArgs.add(recordEndDate);
    }
    if (houseNo != null) {
      whereSql += "AND house_no = ? ";
      whereArgs.add(houseNo);
    }
    if (day != null) {
      whereSql += "AND day = ? ";
      whereArgs.add(day);
    }
    if (isUpload != null) {
      whereSql += "AND is_upload = ? ";
      whereArgs.add(isUpload);
    }
    if (isDelete != null) {
      whereSql += "AND is_delete = ? ";
      whereArgs.add(isDelete);
    }

    final res = await db.query(
      _table,
      where: whereSql,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
    return res.isNotEmpty ? res.map((c) => CfWeight.fromJson(c)).toList() : [];
  }

  Future<CfWeight> getById(int id) async {
    final db = await Db().database;
    final res = await db.query(_table, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? CfWeight.fromJson(res.first) : null;
  }

  Future<int> update(CfWeight cfWeight) async {
    final db = await Db().database;
    return await db.update(
      _table,
      cfWeight.toDbJson(),
      where: "id = ?",
      whereArgs: [cfWeight.id],
    );
  }

  Future<void> remove(int companyId, int locationId, int isUpload) async {
    final db = await Db().database;

    var whereSql = "1 = 1 ";
    final whereArgs = [];
    if (companyId != null) {
      whereSql += "AND company_id = ? ";
      whereArgs.add(companyId);
    }
    if (locationId != null) {
      whereSql += "AND location_id = ? ";
      whereArgs.add(locationId);
    }
    if (isUpload != null) {
      whereSql += "AND is_upload = ? ";
      whereArgs.add(isUpload);
    }

    final res = await db.query(_table, where: whereSql, whereArgs: whereArgs);
    final cfWeightList = res.isNotEmpty ? res.map((c) => CfWeight.fromJson(c)).toList() : [];

    await Future.forEach(cfWeightList, (cfWeight) async {
      await db.delete(_table, where: "id = ?", whereArgs: [cfWeight.id]);
      await CfWeightDetailDao().removeByCfWeightId(cfWeight.id);
    });
  }
}

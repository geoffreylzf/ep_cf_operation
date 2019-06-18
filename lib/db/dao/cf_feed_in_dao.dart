import 'package:ep_cf_operation/db/dao/cf_feed_in_detail_dao.dart';
import 'package:ep_cf_operation/db/db.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in.dart';

const _table = "cf_feed_in";

class CfFeedInDao {
  static final _instance = CfFeedInDao._internal();

  CfFeedInDao._internal();

  factory CfFeedInDao() => _instance;

  Future<int> insert(CfFeedIn cfFeedIn) async {
    final db = await Db().database;
    return await db.insert(_table, cfFeedIn.toDbJson());
  }

  Future<List<CfFeedIn>> searchList({
    int companyId,
    int locationId,
    String recordDate,
    String recordStartDate,
    String recordEndDate,
    String docNo,
    String truckNo,
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
    if (docNo != null && docNo != "") {
      whereSql += "AND doc_no LIKE '%$docNo%' ";
    }
    if (truckNo != null && truckNo != "") {
      whereSql += "AND truck_no LIKE '%$truckNo%' ";
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
    return res.isNotEmpty ? res.map((c) => CfFeedIn.fromJson(c)).toList() : [];
  }

  Future<CfFeedIn> getById(int id) async {
    final db = await Db().database;
    final res = await db.query(_table, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? CfFeedIn.fromJson(res.first) : null;
  }

  Future<int> update(CfFeedIn cfFeedIn) async {
    final db = await Db().database;
    return await db.update(
      _table,
      cfFeedIn.toDbJson(),
      where: "id = ?",
      whereArgs: [cfFeedIn.id],
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
    final cfWeightList = res.isNotEmpty ? res.map((c) => CfFeedIn.fromJson(c)).toList() : [];

    await Future.forEach(cfWeightList, (cfWeight) async {
      await db.delete(_table, where: "id = ?", whereArgs: [cfWeight.id]);
      await CfFeedInDetailDao().removeByCfFeedInId(cfWeight.id);
    });
  }
}

import 'package:ep_cf_operation/db/db.dart';
import 'package:ep_cf_operation/model/table/cf_feed_consumption.dart';

const _table = "cf_feed_consumption";

class CfFeedConsumptionDao {
  static final _instance = CfFeedConsumptionDao._internal();

  CfFeedConsumptionDao._internal();

  factory CfFeedConsumptionDao() => _instance;

  Future<int> insert(CfFeedConsumption cfFeedConsumption) async {
    var db = await Db().database;
    var res = await db.insert(_table, cfFeedConsumption.toJson());
    return res;
  }

  Future<CfFeedConsumption> getById(int id) async {
    final db = await Db().database;
    final res = await db.query(_table, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? CfFeedConsumption.fromJson(res.first) : null;
  }

  Future<int> update(CfFeedConsumption cfFeedConsumption) async {
    final db = await Db().database;
    return await db.update(
      _table,
      cfFeedConsumption.toJson(),
      where: "id = ?",
      whereArgs: [cfFeedConsumption.id],
    );
  }

  Future<List<CfFeedConsumption>> searchList({
    int companyId,
    int locationId,
    String recordDate,
    String recordStartDate,
    String recordEndDate,
    int houseNo,
    String itemTypeCode,
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
    if (itemTypeCode != null) {
      whereSql += "AND item_type_code = ? ";
      whereArgs.add(itemTypeCode);
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
    return res.isNotEmpty ? res.map((c) => CfFeedConsumption.fromJson(c)).toList() : [];
  }

  Future<int> remove(int companyId, int locationId, int isUpload) async {
    var db = await Db().database;

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

    var res = await db.delete(_table, where: whereSql, whereArgs: whereArgs);
    return res;
  }
}

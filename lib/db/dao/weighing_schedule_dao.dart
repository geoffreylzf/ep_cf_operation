import 'package:ep_cf_operation/db/db.dart';
import 'package:ep_cf_operation/model/table/weighing_schedule.dart';

const _table = "weighing_schedule";

class WeighingScheduleDao {
  static final _instance = WeighingScheduleDao._internal();

  WeighingScheduleDao._internal();

  factory WeighingScheduleDao() => _instance;

  Future<int> deleteByLocationId(int locationId) async {
    var db = await Db().database;
    var res = await db.delete(
      _table,
      where: "location_id = ?",
      whereArgs: [locationId],
    );
    return res;
  }

  Future<int> insert(WeighingSchedule weighingSchedule) async {
    var db = await Db().database;
    var res = await db.insert(_table, weighingSchedule.toJson());
    return res;
  }

  Future<List<WeighingSchedule>> getByLocationId(int locationId) async {
    final db = await Db().database;
    final res = await db.query(
      _table,
      where: "location_id = ? and weighing_date > DATE('now')",
      whereArgs: [locationId],
      orderBy: 'weighing_date'
    );
    return res.isNotEmpty ? res.map((c) => WeighingSchedule.fromJson(c)).toList() : [];
  }
}

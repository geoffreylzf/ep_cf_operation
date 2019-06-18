import 'package:ep_cf_operation/db/db.dart';

class UtilDao{
  static final _instance = UtilDao._internal();

  UtilDao._internal();

  factory UtilDao() => _instance;

  Future<int> getPendingUploadCount() async {
    final db = await Db().database;
    final res = await db.rawQuery("""
    SELECT SUM(count) AS count FROM
    (
    SELECT COUNT(*) as count FROM cf_mortality WHERE is_upload = 0
    UNION
    SELECT COUNT(*) as count FROM cf_weight WHERE is_upload = 0
    UNION
    SELECT COUNT(*) as count FROM cf_feed_in WHERE is_upload = 0
    ) A
    """);

    return res.isNotEmpty ? res.first['count'] : 0;
  }
}
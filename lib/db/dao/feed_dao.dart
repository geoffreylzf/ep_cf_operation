import 'package:ep_cf_operation/db/db.dart';
import 'package:ep_cf_operation/model/table/feed.dart';


const _table = "feed";


class FeedDao {
  static final _instance = FeedDao._internal();

  FeedDao._internal();

  factory FeedDao() => _instance;

  Future<int> getCount() async {
    final db = await Db().database;
    final res = await db.rawQuery("""
    SELECT
      COUNT(*) as count
    FROM feed
    """);
    return res.isNotEmpty ? res.first['count'] : 0;
  }

  Future<int> deleteAll() async {
    var db = await Db().database;
    var res = await db.delete(_table);
    return res;
  }

  Future<int> insert(Feed feed) async {
    var db = await Db().database;
    var res = await db.insert(_table, feed.toJson());
    return res;
  }

  Future<Feed> getById(int id) async {
    final db = await Db().database;
    final res = await db.query(_table, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Feed.fromJson(res.first) : null;
  }
}
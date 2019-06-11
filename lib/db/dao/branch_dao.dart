import 'package:ep_cf_operation/db/db.dart';
import 'package:ep_cf_operation/model/table/branch.dart';

const _table = "branch";

class BranchDao {
  static final _instance = BranchDao._internal();

  BranchDao._internal();

  factory BranchDao() => _instance;

  Future<int> getCount() async {
    final db = await Db().database;
    final res = await db.rawQuery("""
    SELECT
      COUNT(*) as count
    FROM branch
    """);
    return res.isNotEmpty ? res.first['count'] : 0;
  }

  Future<List<Branch>> getCompanyList() async {
    final db = await Db().database;
    final res = await db.query(
      _table,
      where: "company_id = 0",
    );
    return res.isNotEmpty ? res.map((c) => Branch.fromJson(c)).toList() : [];
  }

  Future<List<Branch>> getLocationListByCompanyId(int companyId) async {
    final db = await Db().database;
    final res = await db.query(
      _table,
      where: "company_id = ?",
      orderBy: "branch_name",
      whereArgs: [companyId],
    );
    return res.isNotEmpty ? res.map((c) => Branch.fromJson(c)).toList() : [];
  }

  Future<int> deleteAll() async {
    var db = await Db().database;
    var res = await db.delete(_table);
    return res;
  }

  Future<int> insert(Branch branch) async {
    var db = await Db().database;
    var res = await db.insert(_table, branch.toJson());
    return res;
  }

  Future<Branch> getCompanyById(int id) async {
    final db = await Db().database;
    final res = await db.query(_table, where: "id = ? AND company_id = 0", whereArgs: [id]);
    return res.isNotEmpty ? Branch.fromJson(res.first) : null;
  }

  Future<Branch> getLocationById(int id) async {
    final db = await Db().database;
    final res = await db.query(_table, where: "id = ? AND company_id != 0", whereArgs: [id]);
    return res.isNotEmpty ? Branch.fromJson(res.first) : null;
  }
}

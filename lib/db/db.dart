import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'db_sql.dart';

const _version = 1;
const _dbName = "ep_cf_operation.db";

class Db {
  static final _instance = Db._internal();

  factory Db() => _instance;

  Db._internal();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _dbName);

    return await openDatabase(
      path,
      version: _version,
      onCreate: (Database db, int version) async {
        await db.execute(DbSql.createBranchTable);
        await db.execute(DbSql.createCfMortalityTable);

        await db.execute(DbSql.createTempCfWeightDetailTable);
        await db.execute(DbSql.createCfWeightTable);
        await db.execute(DbSql.createCfWeightDetailTable);
      },
    );
  }
}

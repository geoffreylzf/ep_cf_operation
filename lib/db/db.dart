import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'db_sql.dart';

const _version = 3;
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

        await db.execute(DbSql.createFeedTable);
        await db.execute(DbSql.createTempCfFeedInDetailTable);
        await db.execute(DbSql.createCfFeedInTable);
        await db.execute(DbSql.createCfFeedInDetailTable);

        await db.execute(DbSql.createWeighingScheduleTable);

        await db.execute(DbSql.createCfFeedDischargeTable);
        await db.execute(DbSql.createCfFeedDischargeDetailTable);
        await db.execute(DbSql.createTempCfFeedDischargeDetailTable);
        await db.execute(DbSql.createCfFeedReceiveTable);
        await db.execute(DbSql.createCfFeedReceiveDetailTable);
        await db.execute(DbSql.createTempCfFeedReceiveDetailTable);
        await db.execute(DbSql.createCfFeedConsumptionTable);
      },
      onUpgrade: (Database db, int oldVer, int newVer) async {
        if (oldVer <= 1) {
          await db.execute(DbSql.createCfFeedDischargeTable);
          await db.execute(DbSql.createCfFeedDischargeDetailTable);
          await db.execute(DbSql.createTempCfFeedDischargeDetailTable);
          await db.execute(DbSql.createCfFeedReceiveTable);
          await db.execute(DbSql.createCfFeedReceiveDetailTable);
          await db.execute(DbSql.createTempCfFeedReceiveDetailTable);
        }
        if (oldVer <= 2) {
          await db.execute(DbSql.createCfFeedConsumptionTable);
        }
      },
    );
  }
}

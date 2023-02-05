import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:thesis_app/models/portfolio_records_models.dart';

class StockHistoryDatabase {
  static final StockHistoryDatabase instance = StockHistoryDatabase._init();

  static Database? _database;

  StockHistoryDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB("Stock_history.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const integerType = "INTEGER NOT NULL";
    const doubleType = "REAL NOT NULL";
    const textType = "TEXT NOT NULL";
    await db.execute(
      "CREATE TABLE $tablePortfolioStockHistory ("
      "${RecordFields.id} $idType,"
      "${RecordFields.foreignId} $integerType,"
      "${RecordFields.amount} $doubleType,"
      "${RecordFields.date} $textType"
      ")",
    );
  }

  Future<PortfolioInvestmentRecord> createRecord(PortfolioInvestmentRecord record) async {
    final db = await instance.database;
    final id = await db.insert(tablePortfolioStockHistory, record.toJson());
    return record.copy(id: id);
  }

  Future<PortfolioInvestmentRecord?> readRecord(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tablePortfolioStockHistory,
      columns: RecordFields.values,
      where: "${RecordFields.id} = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PortfolioInvestmentRecord.fromJson(maps.first);
    } else {
      throw Exception("ID $id not found");
    }
  }

  Future<List<PortfolioInvestmentRecord>> readAllRecords() async {
    final db = await instance.database;

    final result = await db.query(tablePortfolioStockHistory);
    return result.map((json) => PortfolioInvestmentRecord.fromJson(json)).toList();
  }

  Future<int> deleteRecord(int id) async {
    final db = await instance.database;
    return await db.delete(
      tablePortfolioStockHistory,
      where: "${RecordFields.id} = ?",
      whereArgs: [id],
    );
  }

  Future<List<PortfolioInvestmentRecord>> readRecordsFor(int id) async {
    final db = await instance.database;

    final result = await db.query(
      tablePortfolioStockHistory,
      columns: RecordFields.values,
      where: "${RecordFields.foreignId} = ?",
      whereArgs: [id],
    );

    return result.map((json) => PortfolioInvestmentRecord.fromJson(json)).toList();
  }

  Future deleteAllRecordsFor(int id) async {
    final db = await instance.database;
    return await db.delete(tablePortfolioStockHistory, where: "${RecordFields.foreignId} = ?", whereArgs: [id]);
  }

  Future deleteDatabase() async {
    final db = await instance.database;
    await db.delete(tablePortfolioStockHistory);
  }

  Future closeDatabase() async {
    final db = await instance.database;

    db.close();
  }
}

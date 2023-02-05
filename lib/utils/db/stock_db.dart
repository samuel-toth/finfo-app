import 'package:sqflite/sqflite.dart';
import 'package:thesis_app/models/portfolio_models.dart';
import 'package:path/path.dart';
import 'package:thesis_app/models/portfolio_records_models.dart';
import 'package:thesis_app/utils/db/stock_history_db.dart';

/// Class [StockDatabase] provides an instance of SQLite database from Flutter
/// package [sqflite], which provides methods for CRUD operations on database
/// instance. For more specific queries, raw SQL query is used for operation.
class StockDatabase {
  static final StockDatabase instance = StockDatabase._init();

  static Database? _database;

  StockDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB("stock.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const boolType = "BOOLEAN NOT NULL";
    const doubleType = "REAL NOT NULL";
    const textType = "TEXT NOT NULL";
    await db.execute(
      "CREATE TABLE $tablePortfolioStock ("
      "${PortfolioStockFields.id} $idType,"
      "${PortfolioStockFields.name} $textType,"
      "${PortfolioStockFields.symbol} $textType,"
      "${PortfolioStockFields.amount} $doubleType,"
      "${PortfolioStockFields.isFavourite} $boolType,"
      "${PortfolioStockFields.iconUrl} TEXT,"
      "${PortfolioStockFields.latestPriceUSD} REAL,"
      "${PortfolioStockFields.latestPriceEUR} REAL,"
      "${PortfolioStockFields.latestPriceCZK} REAL,"
      "${PortfolioStockFields.lastUpdated} TEXT,"
      "${PortfolioStockFields.percentageChange1d} REAL"
      ")",
    );
  }

  Future<PortfolioInvestment> createStock(PortfolioStock stock) async {
    final db = await instance.database;
    final id = await db.insert(tablePortfolioStock, stock.toJson());
    await StockHistoryDatabase.instance.createRecord(PortfolioInvestmentRecord(foreignId: id, amount: stock.amount, date: DateTime.now()));
    return stock.copy(id: id);
  }

  Future<PortfolioStock?> readStock(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tablePortfolioStock,
      columns: PortfolioStockFields.values,
      where: "${PortfolioStockFields.id} = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PortfolioStock.fromJson(maps.first);
    } else {
      throw Exception("ID $id not found");
    }
  }

  Future<List<PortfolioStock>> readAllStocks() async {
    final db = await instance.database;

    final result = await db.query(tablePortfolioStock);
    return result.map((json) => PortfolioStock.fromJson(json)).toList();
  }

  Future<List<PortfolioStock>> readFavouriteStocks() async {
    final db = await instance.database;

    final result = await db.rawQuery("SELECT * FROM $tablePortfolioStock WHERE isFavourite = 1");
    return result.map((json) => PortfolioStock.fromJson(json)).toList();
  }

  Future sumUSD() async {
    final db = await instance.database;
    var sum = await db.rawQuery("SELECT SUM(latestPriceUSD * amount) FROM $tablePortfolioStock");
    return sum;
  }

  Future getSUM(String currency) async {
    final db = await instance.database;
    var sum = await db.rawQuery("SELECT SUM(latestPrice$currency * amount) FROM $tablePortfolioStock");
    return sum;
  }

  Future<int> updateStock(PortfolioStock stock) async {
    final db = await instance.database;
    return await db.update(
      tablePortfolioStock,
      stock.toJson(),
      where: "${PortfolioStockFields.id} = ?",
      whereArgs: [stock.id],
    );
  }

  Future<int> updateIcon(String url, int id) async {
    final db = await instance.database;
    return db.rawUpdate("UPDATE $tablePortfolioStock SET iconUrl = ? WHERE _id = ?", [url, id]);
  }

  Future<int> deleteStock(int id) async {
    final db = await instance.database;
    return await db.delete(
      tablePortfolioStock,
      where: "${PortfolioStockFields.id} = ?",
      whereArgs: [id],
    );
  }

  Future deleteDatabase() async {
    final db = await instance.database;
    await db.delete(tablePortfolioStock);
  }

  Future closeDatabase() async {
    final db = await instance.database;

    db.close();
  }
}

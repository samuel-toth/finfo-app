import 'package:sqflite/sqflite.dart';
import 'package:thesis_app/models/portfolio_models.dart';
import 'package:path/path.dart';
import 'package:thesis_app/models/portfolio_records_models.dart';
import 'package:thesis_app/utils/db/crypto_history_db.dart';

/// Class [CryptoDatabase] provides an instance of SQLite database from Flutter
/// package [sqflite], which provides methods for CRUD operations on database
/// instance. For more specific queries, raw SQL query is used for operation.
class CryptoDatabase {
  static final CryptoDatabase instance = CryptoDatabase._init();

  static Database? _database;

  CryptoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB("crypto.db");
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
      "CREATE TABLE $tablePortfolioCrypto ("
      "${PortfolioCryptoFields.id} $idType,"
      "${PortfolioCryptoFields.coinGeckoId} $textType,"
      "${PortfolioCryptoFields.name} $textType,"
      "${PortfolioCryptoFields.symbol} $textType,"
      "${PortfolioCryptoFields.amount} $doubleType,"
      "${PortfolioCryptoFields.isFavourite} $boolType,"
      "${PortfolioCryptoFields.walletNumber} TEXT,"
      "${PortfolioCryptoFields.iconUrl} TEXT,"
      "${PortfolioCryptoFields.latestPriceUSD} REAL,"
      "${PortfolioCryptoFields.latestPriceEUR} REAL,"
      "${PortfolioCryptoFields.latestPriceCZK} REAL,"
      "${PortfolioCryptoFields.lastUpdated} TEXT,"
      "${PortfolioCryptoFields.percentageChange1d} REAL"
      ")",
    );
  }

  Future<PortfolioCrypto> createCrypto(PortfolioCrypto crypto) async {
    final db = await instance.database;
    final id = await db.insert(tablePortfolioCrypto, crypto.toJson());

    await CryptoHistoryDatabase.instance.createRecord(PortfolioInvestmentRecord(foreignId: id, amount: crypto.amount, date: DateTime.now()));

    return crypto.copy(id: id);
  }

  Future<PortfolioCrypto?> readCrypto(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tablePortfolioCrypto,
      columns: PortfolioCryptoFields.values,
      where: "${PortfolioCryptoFields.id} = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PortfolioCrypto.fromJson(maps.first);
    } else {
      throw Exception("ID $id not found");
    }
  }

  Future<List<PortfolioCrypto>> readAllCryptos() async {
    final db = await instance.database;

    final result = await db.query(tablePortfolioCrypto);
    return result.map((json) => PortfolioCrypto.fromJson(json)).toList();
  }

  Future<List<PortfolioCrypto>> readFavouriteCryptos() async {
    final db = await instance.database;

    final result = await db.rawQuery("SELECT * FROM $tablePortfolioCrypto WHERE isFavourite = 1");
    return result.map((json) => PortfolioCrypto.fromJson(json)).toList();
  }

  Future sumUSD() async {
    final db = await instance.database;
    var sum = await db.rawQuery("SELECT SUM(latestPriceUSD * amount) FROM $tablePortfolioCrypto");
    return sum;
  }

  Future sumEUR() async {
    final db = await instance.database;
    var sum = await db.rawQuery("SELECT SUM(latestPriceEUR * amount) FROM $tablePortfolioCrypto");
    return sum;
  }

  Future sumCZK() async {
    final db = await instance.database;
    var sum = await db.rawQuery("SELECT SUM(latestPriceCZK * amount) FROM $tablePortfolioCrypto");
    return sum;
  }

  Future getSUM(String currency) async {
    final db = await instance.database;
    var sum = await db.rawQuery("SELECT SUM(latestPrice$currency * amount) FROM $tablePortfolioCrypto");
    return sum;
  }

  Future<int> updateCrypto(PortfolioCrypto crypto) async {
    final db = await instance.database;
    return db.update(
      tablePortfolioCrypto,
      crypto.toJson(),
      where: "_id=?",
      whereArgs: [crypto.id],
    );
  }

  Future<int> updateIcon(String url, int id) async {
    final db = await instance.database;
    return db.rawUpdate("UPDATE $tablePortfolioCrypto SET iconUrl = ? WHERE _id = ?", [url, id]);
  }

  Future<int> updatePriceUSD(num price, int id) async {
    final db = await instance.database;
    return db.rawUpdate("UPDATE $tablePortfolioCrypto SET latestPriceUSD = ? WHERE _id = ?", [price, id]);
  }

  Future<int> deleteCrypto(int id) async {
    final db = await instance.database;
    return await db.delete(
      tablePortfolioCrypto,
      where: "${PortfolioCryptoFields.id} = ?",
      whereArgs: [id],
    );
  }

  Future deleteDatabase() async {
    final db = await instance.database;
    await db.delete(tablePortfolioCrypto);
  }

  Future closeDatabase() async {
    final db = await instance.database;

    db.close();
  }
}

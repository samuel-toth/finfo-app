const String tablePortfolioCryptoHistory = "porfolio_crypto_history";
const String tablePortfolioStockHistory = "porfolio_stock_history";

class RecordFields {
  static final List<String> values = [id, foreignId, amount, date];
  static const String id = "_id";
  static const String foreignId = "foreignId";
  static const String amount = "amount";
  static const String date = "date";
}

class PortfolioInvestmentRecord {
  final int? id;
  final int foreignId;
  final double amount;
  final DateTime date;

  PortfolioInvestmentRecord({
    this.id,
    required this.foreignId,
    required this.amount,
    required this.date,
  });

  Map<String, Object?> toJson() => {
        RecordFields.id: id,
        RecordFields.foreignId: foreignId,
        RecordFields.amount: amount,
        RecordFields.date: date.toIso8601String(),
      };

  static PortfolioInvestmentRecord fromJson(Map<String, Object?> json) => PortfolioInvestmentRecord(
        id: json[RecordFields.id] as int?,
        foreignId: json[RecordFields.foreignId] as int,
        amount: json[RecordFields.amount] as double,
        date: DateTime.parse(json[RecordFields.date] as String),
      );

  PortfolioInvestmentRecord copy({
    int? id,
    int? foreignId,
    double? amount,
    DateTime? date,
  }) =>
      PortfolioInvestmentRecord(
        id: id ?? this.id,
        foreignId: foreignId ?? this.foreignId,
        amount: amount ?? this.amount,
        date: date ?? this.date,
      );
}

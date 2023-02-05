import 'package:thesis_app/utils/providers/api_provider.dart';

const String tablePortfolioCrypto = "porfolio_crypto";
const String tablePortfolioStock = "porfolio_stock";

class PortfolioCryptoFields {
  static final List<String> values = [
    id,
    coinGeckoId,
    name,
    symbol,
    amount,
    isFavourite,
    walletNumber,
    iconUrl,
    latestPriceUSD,
    latestPriceEUR,
    latestPriceCZK,
    lastUpdated
  ];

  static const String id = "_id";
  static const String coinGeckoId = "coinGeckoId";
  static const String name = "name";
  static const String symbol = "symbol";
  static const String amount = "amount";
  static const String isFavourite = "isFavourite";
  static const String walletNumber = "wallet";
  static const String iconUrl = "iconUrl";
  static const String latestPriceUSD = "latestPriceUSD";
  static const String latestPriceEUR = "latestPriceEUR";
  static const String latestPriceCZK = "latestPriceCZK";
  static const String lastUpdated = "lastUpdated";
  static const String percentageChange1d = "percentageChange1d";
}

class PortfolioStockFields {
  static final List<String> values = [id, name, symbol, amount, isFavourite, iconUrl, latestPriceUSD, latestPriceEUR, latestPriceCZK, lastUpdated];

  static const String id = "_id";
  static const String name = "name";
  static const String symbol = "symbol";
  static const String amount = "amount";
  static const String isFavourite = "isFavourite";
  static const String iconUrl = "iconUrl";
  static const String latestPriceUSD = "latestPriceUSD";
  static const String latestPriceEUR = "latestPriceEUR";
  static const String latestPriceCZK = "latestPriceCZK";
  static const String lastUpdated = "lastUpdated";
  static const String percentageChange1d = "percentageChange1d";
}

class PortfolioInvestment {
  final int? id;
  final String name;
  final String symbol;
  double amount;
  bool isFavourite;

  String? iconUrl;
  double? latestPriceUSD;
  double? latestPriceEUR;
  double? latestPriceCZK;
  DateTime? lastUpdated;

  double? percentageChange1d;

  bool allLoaded = false;

  PortfolioInvestment({
    this.id,
    required this.name,
    required this.symbol,
    required this.amount,
    required this.isFavourite,
    this.iconUrl,
    this.latestPriceUSD,
    this.latestPriceEUR,
    this.latestPriceCZK,
    this.lastUpdated,
    this.percentageChange1d,
  });

  double getLatestPriceUSD() {
    if (latestPriceUSD != null) {
      return latestPriceUSD!;
    } else {
      return 0.0;
    }
  }

  double getLatestPriceEUR() {
    if (latestPriceEUR != null) {
      return latestPriceEUR!;
    } else {
      return 0.0;
    }
  }

  double getLatestPriceCZK() {
    if (latestPriceCZK != null) {
      return latestPriceCZK!;
    } else {
      return 0.0;
    }
  }

  double priceInUSD() {
    if (latestPriceUSD != null) {
      return amount * latestPriceUSD!;
    } else {
      return 0.0;
    }
  }

  double priceInEUR() {
    if (latestPriceEUR != null) {
      return amount * latestPriceEUR!;
    } else {
      return 0.0;
    }
  }

  double priceInCZK() {
    if (latestPriceCZK != null) {
      return amount * latestPriceCZK!;
    } else {
      return 0.0;
    }
  }

  void addShares(num value) {
    amount += value;
  }

  void toggleFavourites() {
    isFavourite = !isFavourite;
  }
}

class PortfolioCrypto extends PortfolioInvestment {
  final String coinGeckoId;
  final String? walletNumber;

  PortfolioCrypto({
    id,
    required this.coinGeckoId,
    required name,
    required symbol,
    required amount,
    required isFavourite,
    this.walletNumber,
    iconUrl,
    latestPriceUSD,
    latestPriceEUR,
    latestPriceCZK,
    lastUpdated,
    percentageChange1d,
  }) : super(
            id: id,
            amount: amount,
            name: name,
            symbol: symbol,
            isFavourite: isFavourite,
            iconUrl: iconUrl,
            latestPriceUSD: latestPriceUSD,
            latestPriceEUR: latestPriceEUR,
            latestPriceCZK: latestPriceCZK,
            percentageChange1d: percentageChange1d,
            lastUpdated: lastUpdated);

  Map<String, Object?> toJson() => {
        PortfolioCryptoFields.id: id,
        PortfolioCryptoFields.coinGeckoId: coinGeckoId,
        PortfolioCryptoFields.name: name,
        PortfolioCryptoFields.symbol: symbol,
        PortfolioCryptoFields.amount: amount,
        PortfolioCryptoFields.isFavourite: isFavourite ? 1 : 0,
        PortfolioCryptoFields.walletNumber: walletNumber,
        PortfolioCryptoFields.iconUrl: iconUrl,
        PortfolioCryptoFields.latestPriceUSD: latestPriceUSD,
        PortfolioCryptoFields.latestPriceEUR: latestPriceEUR,
        PortfolioCryptoFields.latestPriceCZK: latestPriceCZK,
        PortfolioCryptoFields.lastUpdated: lastUpdated != null ? lastUpdated!.toIso8601String() : null,
        PortfolioCryptoFields.percentageChange1d: percentageChange1d,
      };

  static PortfolioCrypto fromJson(Map<String, Object?> json) => PortfolioCrypto(
        id: json[PortfolioCryptoFields.id] as int?,
        coinGeckoId: json[PortfolioCryptoFields.coinGeckoId] as String,
        name: json[PortfolioCryptoFields.name] as String,
        symbol: json[PortfolioCryptoFields.symbol] as String,
        amount: json[PortfolioCryptoFields.amount] as double,
        isFavourite: json[PortfolioCryptoFields.isFavourite] == 1,
        walletNumber: json[PortfolioCryptoFields.walletNumber] as String?,
        iconUrl: json[PortfolioCryptoFields.iconUrl] as String?,
        latestPriceUSD: json[PortfolioCryptoFields.latestPriceUSD] as double?,
        latestPriceEUR: json[PortfolioCryptoFields.latestPriceEUR] as double?,
        latestPriceCZK: json[PortfolioCryptoFields.latestPriceCZK] as double?,
        lastUpdated: json[PortfolioCryptoFields.lastUpdated] != null ? DateTime.parse(json[PortfolioCryptoFields.lastUpdated] as String) : null,
        percentageChange1d: json[PortfolioCryptoFields.percentageChange1d] as double?,
      );

  PortfolioCrypto copy({
    int? id,
    String? coinGeckoId,
    String? name,
    String? symbol,
    double? amount,
    bool? isFavourite,
    String? walletNumber,
    String? iconUrl,
    double? latestPriceUSD,
    double? latestPriceEUR,
    double? latestPriceCZK,
    DateTime? lastUpdated,
  }) =>
      PortfolioCrypto(
        id: id ?? this.id,
        coinGeckoId: coinGeckoId ?? this.coinGeckoId,
        name: name ?? this.name,
        symbol: symbol ?? this.symbol,
        amount: amount ?? this.amount,
        isFavourite: isFavourite ?? this.isFavourite,
        walletNumber: walletNumber ?? this.walletNumber,
        iconUrl: iconUrl ?? this.iconUrl,
        latestPriceUSD: latestPriceUSD ?? this.latestPriceUSD,
        latestPriceEUR: latestPriceEUR ?? this.latestPriceEUR,
        latestPriceCZK: latestPriceCZK ?? this.latestPriceCZK,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
}

class PortfolioStock extends PortfolioInvestment {
  PortfolioStock({
    id,
    required name,
    required symbol,
    required amount,
    required isFavourite,
    iconUrl,
    latestPriceUSD,
    latestPriceEUR,
    latestPriceCZK,
    lastUpdated,
    percentageChange1d,
  }) : super(
            id: id,
            amount: amount,
            name: name,
            symbol: symbol,
            isFavourite: isFavourite,
            iconUrl: iconUrl,
            latestPriceUSD: latestPriceUSD,
            latestPriceEUR: latestPriceEUR,
            latestPriceCZK: latestPriceCZK,
            lastUpdated: lastUpdated,
            percentageChange1d: percentageChange1d);

  Map<String, Object?> toJson() => {
        PortfolioStockFields.id: id,
        PortfolioStockFields.name: name,
        PortfolioStockFields.symbol: symbol,
        PortfolioStockFields.amount: amount,
        PortfolioStockFields.isFavourite: isFavourite ? 1 : 0,
        PortfolioStockFields.iconUrl: iconUrl,
        PortfolioStockFields.latestPriceUSD: latestPriceUSD,
        PortfolioStockFields.latestPriceEUR: latestPriceEUR,
        PortfolioStockFields.latestPriceCZK: latestPriceCZK,
        PortfolioStockFields.lastUpdated: lastUpdated != null ? lastUpdated!.toIso8601String() : null,
        PortfolioStockFields.percentageChange1d: percentageChange1d,
      };

  static PortfolioStock fromJson(Map<String, Object?> json) => PortfolioStock(
        id: json[PortfolioStockFields.id] as int?,
        name: json[PortfolioStockFields.name] as String,
        symbol: json[PortfolioStockFields.symbol] as String,
        amount: json[PortfolioStockFields.amount] as double,
        isFavourite: json[PortfolioStockFields.isFavourite] == 1,
        iconUrl: json[PortfolioStockFields.iconUrl] as String?,
        latestPriceUSD: json[PortfolioStockFields.latestPriceUSD] as double?,
        latestPriceEUR: json[PortfolioStockFields.latestPriceEUR] as double?,
        latestPriceCZK: json[PortfolioStockFields.latestPriceCZK] as double?,
        lastUpdated: json[PortfolioStockFields.lastUpdated] != null ? DateTime.parse(json[PortfolioStockFields.lastUpdated] as String) : null,
        percentageChange1d: json[PortfolioStockFields.percentageChange1d] as double?,
      );
  PortfolioStock copy({
    int? id,
    String? name,
    String? symbol,
    double? amount,
    bool? isFavourite,
    String? iconUrl,
    double? latestPriceUSD,
    double? latestPriceEUR,
    double? latestPriceCZK,
    DateTime? lastUpdated,
  }) =>
      PortfolioStock(
        id: id ?? this.id,
        name: name ?? this.name,
        symbol: symbol ?? this.symbol,
        amount: amount ?? this.amount,
        isFavourite: isFavourite ?? this.isFavourite,
        iconUrl: iconUrl ?? this.iconUrl,
        latestPriceUSD: latestPriceUSD ?? this.latestPriceUSD,
        latestPriceEUR: latestPriceEUR ?? this.latestPriceEUR,
        latestPriceCZK: latestPriceCZK ?? this.latestPriceCZK,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  Future fetchPrice() async {
    final ApiProvider _provider = ApiProvider();
    var response = await _provider.fetchIexPrice(symbol);
    latestPriceUSD = response;
  }

  Future fetchChange() async {
    final ApiProvider _provider = ApiProvider();
    var response = await _provider.fetchIexChange(symbol);
    percentageChange1d = response;
  }

  Future fetchIcon() async {
    final ApiProvider _provider = ApiProvider();
    var response = await _provider.fetchIexIcon(symbol);
    iconUrl = response["url"];
  }
}

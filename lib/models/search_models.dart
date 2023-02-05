class SearchStock {
  final String symbol;
  final String name;
  String? region;
  final String currency;
  String? exchangeName;
  double? latestPrice;
  double? percentageChange1d;
  String? iconUrl;
  String? ceo;
  String? exchange;
  String? website;
  int? volume;
  int? employees;
  String? sector;

  SearchStock({
    required this.name,
    required this.symbol,
    required this.currency,
    this.percentageChange1d,
    this.latestPrice,
  });

  factory SearchStock.fromJSON(Map<String, dynamic> json) {
    return SearchStock(
      symbol: json["symbol"] as String,
      name: json["name"] as String,
      currency: json["currency"] as String,
    );
  }
  factory SearchStock.fromListJSON(Map<String, dynamic> json) {
    return SearchStock(
      symbol: json["symbol"] as String,
      name: json["companyName"] as String,
      currency: json["currency"] as String,
      percentageChange1d: json["changePercent"].toDouble() as double,
      latestPrice: json["latestPrice"].toDouble() as double,
    );
  }
}

class SearchCrypto {
  final String id;
  final String symbol;
  final String name;
  String? iconUrl;
  double? latestPrice;
  double? athPrice;
  int? marketCapRank;
  double? marketCap;
  double? maxSupply;
  double? circulatingSupply;
  double? percentageChange1d;

  SearchCrypto({
    required this.id,
    required this.name,
    required this.symbol,
  });
  int comparePrices(SearchCrypto comparedCrypto) {
    if (latestPrice! < comparedCrypto.latestPrice!) {
      return -1;
    } else if (latestPrice! == comparedCrypto.latestPrice!) {
      return 0;
    } else {
      return 1;
    }
  }

  int compareChange(SearchCrypto comparedCrypto) {
    if (percentageChange1d! < comparedCrypto.percentageChange1d!.toDouble()) {
      return -1;
    } else if (percentageChange1d! == comparedCrypto.percentageChange1d) {
      return 0;
    } else {
      return 1;
    }
  }

  int compareRank(SearchCrypto comparedCrypto) {
    if (marketCapRank! < comparedCrypto.marketCapRank!) {
      return -1;
    } else if (marketCapRank! == comparedCrypto.marketCapRank!) {
      return 0;
    } else {
      return 1;
    }
  }
}

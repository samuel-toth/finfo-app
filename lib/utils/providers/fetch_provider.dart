import 'package:thesis_app/models/news_model.dart';
import 'package:thesis_app/models/portfolio_models.dart';
import 'package:thesis_app/models/search_models.dart';

import 'package:thesis_app/utils/db/crypto_db.dart';
import 'package:thesis_app/utils/db/stock_db.dart';
import 'package:thesis_app/utils/providers/api_provider.dart';

///
/// FetchProvider provides methods for fetching relevant data and converting
/// them from JSON format to corresponding objects.
///

class FetchProvider {
  final ApiProvider _provider = ApiProvider();

  Future fetchCompletePortfolioCryptoData(List<PortfolioCrypto> cryptos) async {
    for (var crypto in cryptos) {
      if (crypto.lastUpdated == null || (crypto.lastUpdated!.difference(DateTime.now()).inMinutes > 1)) {
        var data = await _provider.fetchCoinGeckoFullData(crypto.coinGeckoId);
        crypto.iconUrl ??= data["image"]["small"];
        crypto.latestPriceUSD = data["market_data"]["current_price"]["usd"].toDouble();
        crypto.latestPriceEUR = data["market_data"]["current_price"]["eur"].toDouble();
        crypto.latestPriceCZK = data["market_data"]["current_price"]["czk"].toDouble();
        crypto.percentageChange1d = data["market_data"]["price_change_percentage_24h"] as double;
        crypto.lastUpdated = DateTime.now();
      }
      await CryptoDatabase.instance.updateCrypto(crypto);
    }
  }

  Future fetchCompletePortfolioStockData(List<PortfolioStock> stocks) async {
    for (var stock in stocks) {
      if (stock.lastUpdated == null || (stock.lastUpdated!.difference(DateTime.now()).inMinutes > 1)) {
        var marketData = await _provider.fetchIexCurrentMarketData(stock.symbol);
        if (stock.iconUrl == null) {
          var logoData = await _provider.fetchIexIcon(stock.symbol);
          stock.iconUrl = logoData["url"];
        }
        stock.latestPriceUSD = marketData[0].toDouble();
        stock.percentageChange1d = marketData[1].toDouble();
        double rateEUR = marketData[2][0]["rate"].toDouble();
        double rateCZK = marketData[2][1]["rate"].toDouble();
        stock.latestPriceEUR = stock.latestPriceUSD! * rateEUR;
        stock.latestPriceCZK = stock.latestPriceUSD! * rateCZK;
        stock.lastUpdated = DateTime.now();
      }
      await StockDatabase.instance.updateStock(stock);
    }
  }

  Future fetchCompleteSearchData(List<SearchStock> items, String prefCurrency) async {
    for (var stock in items) {
      var marketData = await _provider.fetchIexCompleteSearchData(stock.symbol, stock.currency, prefCurrency);
      stock.ceo = marketData[0]["CEO"] ?? "-";
      stock.employees = marketData[0]["employees"] ?? 0;
      stock.sector = marketData[0]["sector"] ?? "-";
      stock.exchange = marketData[0]["exchange"] ?? "-";
      stock.percentageChange1d = marketData[3].toDouble() ?? 0;
      stock.iconUrl = marketData[4]["url"] ?? "";
      stock.latestPrice = marketData[2].toDouble() ?? 0.0;
      if (marketData[1] != null && marketData[2] != null) {
        double tempA = marketData[1][0]["rate"].toDouble() ?? 0.0;
        double tempB = marketData[2].toDouble() ?? 0.0;
        stock.latestPrice = tempA * tempB;
      }
    }
  }

  Future fetchCompleteCategoryData(List<SearchStock> items, String prefCurrency) async {
    for (var stock in items) {
      var marketData = await _provider.fetchIexCompleteSearchData(stock.symbol, stock.currency, prefCurrency);
      stock.ceo = marketData[0]["CEO"] ?? "-";
      stock.employees = marketData[0]["employees"] ?? 0;
      stock.sector = marketData[0]["sector"] ?? "-";
      stock.exchange = marketData[0]["exchange"] ?? "-";

      stock.iconUrl = marketData[4]["url"] ?? "";
      stock.latestPrice = marketData[2].toDouble() ?? 0.0;
      if (marketData[1] != null) {
        double tempA = marketData[1][0]["rate"].toDouble() ?? 0.0;
        stock.latestPrice = tempA * stock.latestPrice!;
      }
    }
  }

  Future<List<SearchStock>> fetchSearch(String text) async {
    List<SearchStock> items = [];
    var response = await _provider.fetchIexSearch(text);
    for (var result in response) {
      if (result["securityType"] == "cs" && result["region"] == "US") {
        items.add(SearchStock.fromJSON(result));
      }
    }
    return items;
  }

  Future<List<SearchStock>> fetchByCategory(String text) async {
    List<SearchStock> items = [];
    var response = await _provider.fetchIexCompaniesList(text);
    for (var result in response) {
      items.add(SearchStock.fromListJSON(result));
    }
    return items;
  }

  Future fetchSearchCryptos(String currency) async {
    var result = await _provider.fetchCoinGeckoCoins(currency);
    List<SearchCrypto> list = [];
    for (var crypto in result) {
      var temp = SearchCrypto(id: crypto["id"], name: crypto["name"], symbol: crypto["symbol"]);
      temp.latestPrice = crypto["current_price"] != null ? crypto["current_price"].toDouble() : 0;
      temp.iconUrl = crypto["image"] ?? "";
      temp.marketCapRank = crypto["market_cap_rank"] ?? 0;
      temp.marketCap = crypto["market_cap"] != null ? crypto["market_cap"].toDouble() : 0;
      temp.maxSupply = crypto["max_supply"] != null ? crypto["max_supply"].toDouble() : 0;
      temp.circulatingSupply = crypto["circulating_supply"] != null ? crypto["circulating_supply"].toDouble() : 0;
      temp.athPrice = crypto["ath"] != null ? crypto["ath"].toDouble() : 0;
      temp.percentageChange1d = crypto["price_change_percentage_24h"] != null ? crypto["price_change_percentage_24h"].toDouble() : 0;
      list.add(temp);
    }
    return list;
  }

  Future<List<Article>> fetchNewsArticles(String selectedTag, int pageNumber) async {
    var jsonResponse = await _provider.fetchNewsAPI(selectedTag, 10, pageNumber);
    List<Article> articles = [];
    for (var i = 0; i < jsonResponse["articles"].length; i++) {
      articles.add(Article.fromJson(jsonResponse["articles"][i]));
    }
    return articles;
  }
}

import 'package:coingecko_dart/coingecko_dart.dart';
import 'package:coingecko_dart/dataClasses/coins/Coin.dart';
import 'package:coingecko_dart/dataClasses/coins/CoinDataPoint.dart';
import 'package:coingecko_dart/dataClasses/coins/FullCoin.dart';

/// CoinGeckoProvider uses class [CoinGeckoApi] from Flutter package [CoinGecko]
/// as API instance for fetching cryptocurrency data. Returns [List] for
/// successful call.
class CoinGeckoProvider {
  CoinGeckoApi apiInstance = CoinGeckoApi();

  Future<List<Coin>> fetchListCoins() async {
    var results = await apiInstance.listCoins();
    return results.data;
  }

  Future<List<FullCoin>> fetchListFullCoins() async {
    var results = await apiInstance.getCoinMarkets(vsCurrency: "usd");
    return results.data;
  }

  Future<List<CoinDataPoint>> fetchHistoryFor(String id) async {
    var results = await apiInstance.getCoinMarketChart(id: id, vsCurrency: "usd", days: 1);
    var spots = results.data;
    return spots;
  }
}

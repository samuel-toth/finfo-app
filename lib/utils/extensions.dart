import 'package:coingecko_dart/dataClasses/coins/FullCoin.dart';

///
/// Extension on class [FullCoin] from Flutter package [CoinGecko], that
/// implements functions, used for sorting lists of [FullCoin]
///
extension Comparing on FullCoin {
  int comparePrices(FullCoin comparedCrypto) {
    if (currentPrice! < comparedCrypto.currentPrice!.toDouble()) {
      return -1;
    } else if (currentPrice! == comparedCrypto.currentPrice!.toDouble()) {
      return 0;
    } else {
      return 1;
    }
  }

  int compareChange(FullCoin comparedCrypto) {
    if (priceChangePercentage24h! < comparedCrypto.priceChangePercentage24h!.toDouble()) {
      return -1;
    } else if (priceChangePercentage24h! == comparedCrypto.priceChangePercentage24h) {
      return 0;
    } else {
      return 1;
    }
  }

  int compareRank(FullCoin comparedCrypto) {
    if (marketCapRank! < comparedCrypto.marketCapRank!) {
      return -1;
    } else if (marketCapRank! == comparedCrypto.marketCapRank!) {
      return 0;
    } else {
      return 1;
    }
  }
}

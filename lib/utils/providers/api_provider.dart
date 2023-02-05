// ignore_for_file: prefer_typing_uninitialized_variables, constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:thesis_app/utils/exceptions.dart';

///
/// ApiProvider provides methods for network calls.
/// Coresponding methods throw [Exception], if the call fails or if the status code
/// is not 200, otherwise they return [responseBody] in JSON format
///
class ApiProvider {
  /// Makes network call for passed [url] and uses [returnResponse] for checking
  /// the correctness of the data. Returns [responseJson] for correct data,
  /// otherwise throws [Exception]
  Future<dynamic> getResponse(String url) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(url));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException('Could not fetch data from server.');
      case 401:
      case 403:
        throw UnauthorisedException('Could not fetch data from server.');
      default:
        throw FetchDataException('Error occured while Communication with Server with StatusCode : ${response.statusCode}.');
    }
  }

  Future fetchIexSearch(String symbol) async {
    final responseBody = await getResponse(iexSearch(symbol));
    return responseBody;
  }

  Future fetchIexIcon(String symbol) async {
    final responseBody = await getResponse(iexLogo(symbol));
    return responseBody;
  }

  Future fetchIexCompleteData(String symbol) async {
    final responseBody =
        await Future.wait([getResponse(iexCompany(symbol)), getResponse(iexPrice(symbol)), getResponse(iexChange(symbol)), getResponse(iexLogo(symbol))]);
    return responseBody;
  }

  Future fetchIexCurrentMarketData(String symbol) async {
    final responseBody = await Future.wait([getResponse(iexPrice(symbol)), getResponse(iexChange(symbol)), getResponse(iexCurrencyConversion())]);
    return responseBody;
  }

  /// Makes several network calls and wait for all of them to finish. Returns
  /// [responseBody] if no error occured.
  Future fetchIexCompleteSearchData(String symbol, String symbolCurrency, String currency) async {
    final responseBody = await Future.wait([
      getResponse(iexCompany(symbol)),
      getResponse(iexOneCurrencConversion(symbolCurrency, currency)),
      getResponse(iexPrice(symbol)),
      getResponse(iexChange(symbol)),
      getResponse(iexLogo(symbol))
    ]);
    return responseBody;
  }

  Future fetchIexCompaniesList(String listCategory) async {
    final responseBody = await getResponse(iexCompaniesList(listCategory.toLowerCase()));
    return responseBody;
  }

  Future fetchIexHistoricalPrices(String symbol, String range) async {
    final responseBody = await getResponse(iexHistoricalPrices(symbol, range));
    return responseBody;
  }

  Future fetchIexHistoricalMonthPrices(String symbol) async {
    final responseBody = await getResponse(iexHistoricalMonthlyPrices(symbol));
    return responseBody;
  }

  Future fetchIexPrice(String symbol) async {
    final responseBody = await getResponse(iexPrice(symbol.toLowerCase()));
    return responseBody;
  }

  Future fetchIexChange(String symbol) async {
    final responseBody = await getResponse(iexChange(symbol.toLowerCase()));
    return responseBody;
  }

  Future fetchNewsAPI(String keyword, int pageSize, int page) async {
    final responseBody = await getResponse(newsByCategory(keyword, pageSize, page));
    return responseBody;
  }

  Future fetchCoinGeckoMarketChart(String id, int days, {String currency = "usd"}) async {
    final responseBody = await getResponse(coinGeckoMarketChart(id, days, currency: currency));
    return responseBody;
  }

  Future fetchCoinGeckoFullData(String id) async {
    final responseBody = await getResponse(coinGeckoFullData(id));
    return responseBody;
  }

  Future fetchCoinGeckoCoins(String currency) async {
    final responseBody = await getResponse(coinGeckoCoinList(currency));
    return responseBody;
  }


  static const String NEWS_API_KEY = "NEWS_API_KEY";
  static const String IEX_API_KEY = "IEX_API_KEY";

  String iexPrice(String keyword) {
    return "https://cloud.iexapis.com/stable/stock/$keyword/price?token=$IEX_API_KEY";
  }

  String iexSearch(String keyword) {
    return "https://cloud.iexapis.com/stable/search/$keyword?token=$IEX_API_KEY";
  }

  String iexQuote(String keyword) {
    return "https://cloud.iexapis.com/stable/stock/$keyword/quote?token=$IEX_API_KEY";
  }

  String iexChange(String keyword) {
    return "https://cloud.iexapis.com/stable/stock/$keyword/quote/change?token=$IEX_API_KEY";
  }

  String iexCompany(String keyword) {
    return "https://cloud.iexapis.com/stable/stock/$keyword/company?token=$IEX_API_KEY";
  }

  String iexLogo(String keyword) {
    return "https://cloud.iexapis.com/stable/stock/$keyword/logo?token=$IEX_API_KEY";
  }

  String iexHistoricalPrices(String keyword, String range) {
    return "https://cloud.iexapis.com/stable/stock/$keyword/chart/1y?chartCloseOnly=true&includeToday=true&token=$IEX_API_KEY";
  }

  String iexHistoricalMonthlyPrices(String keyword) {
    return "https://cloud.iexapis.com/stable/stock/$keyword/chart/1mm?includeToday=true&token=$IEX_API_KEY";
  }

  String iexCurrencyConversion() {
    return "https://cloud.iexapis.com/stable/fx/convert?symbols=USDEUR,USDCZK&token=$IEX_API_KEY";
  }

  String iexOneCurrencConversion(String from, String to) {
    return "https://cloud.iexapis.com/stable/fx/convert?symbols=${from.toUpperCase()}${to.toUpperCase()}&token=$IEX_API_KEY";
  }

  String iexCompaniesList(String listCategory) {
    return "https://cloud.iexapis.com/stable/stock/market/list/$listCategory?displayPercent=true&token=$IEX_API_KEY";
  }

  String newsByCategory(String keyword, int pageSize, int page) {
    return "https://newsapi.org/v2/everything?q=$keyword&domains=wired.com,reuters.com,economist.com,gizmodo.com,nytimes.com,theverge.com,techcrunch.com,businessinsider.com,bloomberg.com,fortune.com,wsj.com&pageSize=$pageSize&page=$page&apikey=$NEWS_API_KEY";
  }

  String coinGeckoCryptoData(String id) {
    return "https://api.coingecko.com/api/v3/coins/$id";
  }

  String coinGeckoCoinList(String currency) {
    return "https://api.coingecko.com/api/v3/coins/markets?vs_currency=${currency.toLowerCase()}&order=market_cap_desc&per_page=100&page=1&sparkline=false";
  }

  String coinGeckoMarketChart(String id, int days, {String currency = "usd"}) {
    return "https://api.coingecko.com/api/v3/coins/$id/market_chart?vs_currency=$currency&days=$days";
  }

  String coinGeckoFullData(String id) {
    return "https://api.coingecko.com/api/v3/coins/$id?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false";
  }
}

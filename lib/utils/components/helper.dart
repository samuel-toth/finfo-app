import 'package:intl/intl.dart';
import 'package:thesis_app/models/portfolio_models.dart';
import 'package:thesis_app/models/search_models.dart';
import 'package:thesis_app/utils/db/crypto_db.dart';
import 'package:thesis_app/utils/db/stock_db.dart';
import 'package:thesis_app/utils/enums.dart';

Future<double> getPorfolioSum(SelectedCurrency currency) async {
  var cryptoSum = await CryptoDatabase.instance.getSUM(currency.asString);
  var stockSum = await StockDatabase.instance.getSUM(currency.asString);

  double sS = stockSum[0]["SUM(latestPrice${currency.asString.toUpperCase()} * amount)"] ?? 0;
  double cS = cryptoSum[0]["SUM(latestPrice${currency.asString.toUpperCase()} * amount)"] ?? 0;

  return double.parse((sS + cS).toStringAsFixed(2));
}

String getInvestmentPrice(PortfolioInvestment investment, SelectedCurrency currency) {
  switch (currency) {
    case SelectedCurrency.usd:
      {
        return currencyFormatter(double.parse(investment.priceInUSD().toStringAsFixed(2)), currency.asString);
      }
    case SelectedCurrency.eur:
      {
        return currencyFormatter(double.parse(investment.priceInEUR().toStringAsFixed(2)), currency.asString);
      }
    case SelectedCurrency.czk:
      {
        return currencyFormatter(double.parse(investment.priceInCZK().toStringAsFixed(2)), currency.asString);
      }
    default:
      {
        return currencyFormatter(double.parse(investment.priceInUSD().toStringAsFixed(2)), currency.asString);
      }
  }
}

double getInvestmentPriceAsDouble(PortfolioInvestment investment, SelectedCurrency currency) {
  switch (currency) {
    case SelectedCurrency.usd:
      {
        return investment.getLatestPriceUSD();
      }
    case SelectedCurrency.eur:
      {
        return investment.getLatestPriceEUR();
      }
    case SelectedCurrency.czk:
      {
        return investment.getLatestPriceCZK();
      }
    default:
      {
        return investment.getLatestPriceUSD();
      }
  }
}

currencyFormatter(double amount, String currency) {
  switch (currency) {
    case "USD":
      {
        var formatter = NumberFormat.currency(symbol: "\$", locale: "en-us");
        formatter.minimumFractionDigits = 2;
        formatter.maximumFractionDigits = 5;
        return formatter.format(amount);
      }
    case "EUR":
      {
        var formatter = NumberFormat.currency(symbol: "€", locale: "sk");
        formatter.minimumFractionDigits = 2;
        formatter.maximumFractionDigits = 5;
        return formatter.format(amount);
      }
    case "CZK":
      {
        var formatter = NumberFormat.currency(symbol: "Kč", locale: "cs");
        formatter.minimumFractionDigits = 2;
        formatter.maximumFractionDigits = 5;
        return formatter.format(amount);
      }
    default:
      {
        var formatter = NumberFormat.currency(symbol: "\$");
        formatter.minimumFractionDigits = 2;
        formatter.maximumFractionDigits = 5;
        return formatter.format(amount);
      }
  }
}

formatDateTime(DateTime date) {
  return DateFormat("d.M.yyyy").format(date);
}

formatDateTimeForGraph(DateTime date) {
  return DateFormat("d.M.yyyy hh:MM").format(date);
}

List<SearchCrypto> sortCoinList(List<SearchCrypto> coins, SelectedSort sort) {
  List<SearchCrypto> items = coins;
  switch (sort) {
    case SelectedSort.marketRank:
      {
        items.sort((a, b) => a.compareRank(b));
        break;
      }
    case SelectedSort.highestPrice:
      {
        items.sort((a, b) => a.comparePrices(b));
        items = items.reversed.toList();
        break;
      }
    case SelectedSort.lowestPrice:
      {
        items.sort((a, b) => a.comparePrices(b));
        break;
      }
    case SelectedSort.highestChange:
      {
        items.sort((a, b) => a.compareChange(b));
        items = items.reversed.toList();

        break;
      }
    case SelectedSort.lowestChange:
      {
        items.sort((a, b) => a.compareChange(b));
        break;
      }
  }
  return items;
}

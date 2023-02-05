enum SelectedCurrency { usd, eur, czk }

extension SelectedCurrencyExtension on SelectedCurrency {
  String get asString {
    switch (this) {
      case SelectedCurrency.usd:
        return "USD";
      case SelectedCurrency.eur:
        return "EUR";
      case SelectedCurrency.czk:
        return "CZK";
    }
  }

  int get index {
    switch (this) {
      case SelectedCurrency.usd:
        return 0;
      case SelectedCurrency.eur:
        return 1;
      case SelectedCurrency.czk:
        return 2;
    }
  }

  String get locale {
    switch (this) {
      case SelectedCurrency.usd:
        return "en-us";
      case SelectedCurrency.eur:
        return "sk";
      case SelectedCurrency.czk:
        return "cs";
    }
  }

  String get symbol {
    switch (this) {
      case SelectedCurrency.usd:
        return "\$";
      case SelectedCurrency.eur:
        return "€";
      case SelectedCurrency.czk:
        return "Kč";
    }
  }
}

SelectedCurrency currencyFromText(String text) {
  switch (text.toLowerCase()) {
    case "usd":
      return SelectedCurrency.usd;
    case "eur":
      return SelectedCurrency.eur;
    case "czk":
      return SelectedCurrency.czk;

    default:
      return SelectedCurrency.usd;
  }
}

enum SelectedSort { marketRank, highestPrice, lowestPrice, highestChange, lowestChange }

extension SelectedSortExtension on SelectedSort {
  String get name {
    switch (this) {
      case SelectedSort.marketRank:
        return "Market rank";
      case SelectedSort.highestPrice:
        return "Highest price";
      case SelectedSort.lowestPrice:
        return "Lowest price";
      case SelectedSort.highestChange:
        return "Highest change";
      case SelectedSort.lowestChange:
        return "Lowest change";
    }
  }

  int get index {
    switch (this) {
      case SelectedSort.marketRank:
        return 0;
      case SelectedSort.highestPrice:
        return 1;
      case SelectedSort.lowestPrice:
        return 2;
      case SelectedSort.highestChange:
        return 3;
      case SelectedSort.lowestChange:
        return 4;
    }
  }
}

enum NewsCategory { business, stockMarket, cryptocurrencies, technology }

extension NewsCategoryExtension on NewsCategory {
  String get name {
    switch (this) {
      case NewsCategory.business:
        return "business";
      case NewsCategory.cryptocurrencies:
        return "cryptocurrencies";
      case NewsCategory.stockMarket:
        return "stock_market";
      case NewsCategory.technology:
        return "technology";
    }
  }

  int get index {
    switch (this) {
      case NewsCategory.business:
        return 0;
      case NewsCategory.cryptocurrencies:
        return 1;
      case NewsCategory.stockMarket:
        return 2;
      case NewsCategory.technology:
        return 3;
    }
  }
}

NewsCategory newsCategoryFromText(String text) {
  switch (text) {
    case "business":
      return NewsCategory.business;
    case "cryptocurrencies":
      return NewsCategory.cryptocurrencies;
    case "stock_market":
      return NewsCategory.stockMarket;
    case "technology":
      return NewsCategory.technology;
    default:
      return NewsCategory.business;
  }
}

enum StockListCategory {
  mostactive,
  gainers,
  losers,
}

extension StockListCategoryExtension on StockListCategory {
  String get name {
    switch (this) {
      case StockListCategory.mostactive:
        return "mostactive";
      case StockListCategory.gainers:
        return "gainers";
      case StockListCategory.losers:
        return "losers";
    }
  }

  int get index {
    switch (this) {
      case StockListCategory.mostactive:
        return 0;
      case StockListCategory.gainers:
        return 1;
      case StockListCategory.losers:
        return 2;
    }
  }
}

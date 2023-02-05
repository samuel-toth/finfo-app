import 'package:flutter/material.dart';
import 'package:thesis_app/models/portfolio_models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thesis_app/utils/components/portfolio_card_widget.dart';
import 'package:thesis_app/utils/enums.dart';

class FavouritesWidget extends StatelessWidget {
  final List<PortfolioCrypto> favouriteCryptos;
  final List<PortfolioStock> favouriteStocks;
  final SelectedCurrency currency;
  final bool isLoading;
  const FavouritesWidget({Key? key, required this.favouriteCryptos, required this.favouriteStocks, required this.currency, required this.isLoading})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (favouriteCryptos.isEmpty && favouriteStocks.isEmpty) {
      return Text(AppLocalizations.of(context)!.noPinned);
    }

    if (favouriteCryptos.isNotEmpty && favouriteStocks.isEmpty) {
      return Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(AppLocalizations.of(context)!.cryptos, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
        FavouriteCryptosListView(favouriteCryptos: favouriteCryptos, currency: currency, isLoading: isLoading),
      ]);
    } else if (favouriteCryptos.isEmpty && favouriteStocks.isNotEmpty) {
      return Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                AppLocalizations.of(context)!.stocks,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        FavouriteStocksListView(favouriteStocks: favouriteStocks, currency: currency, isLoading: isLoading)
      ]);
    } else {
      return Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(AppLocalizations.of(context)!.cryptos, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
        FavouriteCryptosListView(favouriteCryptos: favouriteCryptos, currency: currency, isLoading: isLoading),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(AppLocalizations.of(context)!.stocks, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
        FavouriteStocksListView(favouriteStocks: favouriteStocks, currency: currency, isLoading: isLoading)
      ]);
    }
  }
}

class FavouriteStocksListView extends StatelessWidget {
  const FavouriteStocksListView({
    Key? key,
    required this.favouriteStocks,
    required this.currency,
    required this.isLoading,
  }) : super(key: key);

  final List<PortfolioStock> favouriteStocks;
  final SelectedCurrency currency;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: favouriteStocks.length,
      itemBuilder: (context, index) {
        return PortfolioInvestmentCard(investment: favouriteStocks[index], currency: currency, isLoading: isLoading);
      },
    );
  }
}

class FavouriteCryptosListView extends StatelessWidget {
  const FavouriteCryptosListView({
    Key? key,
    required this.favouriteCryptos,
    required this.currency,
    required this.isLoading,
  }) : super(key: key);

  final List<PortfolioCrypto> favouriteCryptos;
  final SelectedCurrency currency;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: favouriteCryptos.length,
      itemBuilder: (context, index) {
        return PortfolioInvestmentCard(investment: favouriteCryptos[index], currency: currency, isLoading: isLoading);
      },
    );
  }
}

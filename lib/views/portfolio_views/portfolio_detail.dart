import 'package:flutter/material.dart';
import 'package:thesis_app/models/portfolio_models.dart';
import 'package:thesis_app/views/portfolio_views/stock/list_stock_portfolio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'crypto/list_crypto_portfolio.dart';

class PortfolioDetail extends StatefulWidget {
  const PortfolioDetail({Key? key}) : super(key: key);

  @override
  State<PortfolioDetail> createState() => _PortfolioDetailState();
}

class _PortfolioDetailState extends State<PortfolioDetail> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

  late String currency;
  late List<PortfolioCrypto> cryptos;
  late List<PortfolioStock> stocks;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.cryptos.toUpperCase()),
              Tab(text: AppLocalizations.of(context)!.stocks.toUpperCase()),
            ],
          ),
          title: Text(
            AppLocalizations.of(context)!.portfolio,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: const TabBarView(
          children: [
            CryptoPortfolio(),
            StockPorfolio(),
          ],
        ),
      ),
    );
  }
}

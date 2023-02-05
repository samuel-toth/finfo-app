import 'package:flutter/material.dart';
import 'package:thesis_app/views/search_views/crypto/list_crypto_search.dart';
import 'package:thesis_app/views/search_views/stock/list_stock_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchDetail extends StatefulWidget {
  const SearchDetail({Key? key}) : super(key: key);

  @override
  State<SearchDetail> createState() => _SearchDetailState();
}

class _SearchDetailState extends State<SearchDetail> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;

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
            AppLocalizations.of(context)!.search,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: const TabBarView(
          children: [
            CryptoSearch(),
            StockSearch(),
          ],
        ),
      ),
    );
  }
}

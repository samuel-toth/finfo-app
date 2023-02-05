import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesis_app/models/search_models.dart';
import 'package:thesis_app/utils/components/drop_down_menus/search_crypto_dropdown.dart';
import 'package:thesis_app/utils/components/helper.dart';
import 'package:thesis_app/utils/components/search_row_cards.dart';
import 'package:thesis_app/utils/enums.dart';
import 'package:thesis_app/utils/providers/fetch_provider.dart';

import 'package:thesis_app/views/search_views/crypto/detail_crypto_search.dart';

class CryptoSearch extends StatefulWidget {
  const CryptoSearch({Key? key}) : super(key: key);

  @override
  _CryptoSearchState createState() => _CryptoSearchState();
}

class _CryptoSearchState extends State<CryptoSearch> with AutomaticKeepAliveClientMixin<CryptoSearch> {
  @override
  bool get wantKeepAlive => true;

  bool isLoading = false;
  List<SearchCrypto> cryptos = [];
  List<SearchCrypto> cryptosToDisplay = [];

  final controller = TextEditingController();
  SelectedSort selectedSort = SelectedSort.marketRank;
  final FetchProvider fetchProvider = FetchProvider();
  late SelectedCurrency currency;
  bool internetConnection = true;

  @override
  void initState() {
    super.initState();
    getCurrency();
    loadCryptos();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshCryptos,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    filled: true,
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.text = "";
                        setState(() {
                          cryptosToDisplay = cryptos;
                        });
                      },
                    ),
                    suffixIcon: const Icon(Icons.search),
                    hintText: AppLocalizations.of(context)!.searchWord,
                  ),
                  onChanged: (text) {
                    text = text.toLowerCase();
                    setState(() {
                      cryptosToDisplay =
                          cryptos.where((element) => element.name.toLowerCase().contains(text) || element.symbol.toLowerCase().contains(text)).toList();
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                SearchSortDropdownMenu(selectedSort: selectedSort, update: changeSelectedSort),
              ]),
            ),
            !internetConnection
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.signal_wifi_off, size: 30, color: Colors.grey),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.signal_cellular_off, size: 30, color: Colors.grey)
                        ],
                      ),
                    ),
                  )
                : Flexible(
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : ListView.builder(
                            itemCount: cryptosToDisplay.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailCryptoSearch(passedCrypto: cryptosToDisplay[index], passedCurrency: currency)));
                                },
                                child: SearchCryptoRowCard(
                                  crypto: cryptosToDisplay[index],
                                  currency: currency,
                                ),
                              );
                            }),
                  ),
          ],
        ),
      ),
    );
  }

  void changeSelectedSort(SelectedSort newSort) {
    setState(() {
      selectedSort = newSort;
      cryptosToDisplay = sortCoinList(cryptosToDisplay, selectedSort);
    });
  }

  Future getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString("currency") != null ? currencyFromText(prefs.getString("currency")!) : SelectedCurrency.usd;
  }

  Future refreshCryptos() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString("currency") != null ? currencyFromText(prefs.getString("currency")!) : SelectedCurrency.usd;

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      cryptos = await fetchProvider.fetchSearchCryptos(currency.asString);

      internetConnection = true;
    } else {
      internetConnection = false;
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future loadCryptos() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString("currency") != null ? currencyFromText(prefs.getString("currency")!) : SelectedCurrency.usd;

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      cryptos = await fetchProvider.fetchSearchCryptos(currency.asString);
      cryptosToDisplay = cryptos;

      internetConnection = true;
    } else {
      internetConnection = false;
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }
}

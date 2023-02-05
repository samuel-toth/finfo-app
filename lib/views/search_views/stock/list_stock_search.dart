import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesis_app/models/search_models.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thesis_app/utils/components/search_row_cards.dart';
import 'package:thesis_app/utils/components/drop_down_menus/search_stock_dropdown.dart';
import 'package:thesis_app/utils/enums.dart';
import 'package:thesis_app/utils/providers/fetch_provider.dart';
import 'package:thesis_app/views/search_views/stock/detail_stock_search.dart';

class StockSearch extends StatefulWidget {
  const StockSearch({Key? key}) : super(key: key);

  @override
  _StockSearchState createState() => _StockSearchState();
}

class _StockSearchState extends State<StockSearch> with AutomaticKeepAliveClientMixin<StockSearch> {
  @override
  bool get wantKeepAlive => true;

  final controller = TextEditingController();
  late List<SearchStock> items;
  late List<SearchStock> itemsToDisplay;

  bool isLoading = false;
  bool isLoadingCompleteData = true;

  late SelectedCurrency currency;
  StockListCategory prefStockCategory = StockListCategory.mostactive;
  bool internetConnection = true;

  final FetchProvider fetchProvider = FetchProvider();

  @override
  void initState() {
    super.initState();
    initCategoryList();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Column(
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
                      controller.clear();
                      clearCryptoList();
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      initSearchStocks();
                    },
                  ),
                  hintText: AppLocalizations.of(context)!.searchWord,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              SearchCategoryDropdownMenu(prefStockCategory: prefStockCategory, update: updateCategory),
            ]),
          ),
          !internetConnection
              ? Padding(
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
                )
              : Flexible(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailStockSearch(
                                            passedStock: items[index],
                                            passedCurrency: currency,
                                          )),
                                );
                              },
                              child: searchStockRowCard(context, items[index], currency, isLoadingCompleteData),
                            );
                          }),
                ),
        ],
      ),
    );
  }

  void updateCategory(StockListCategory cat) {
    setState(() => prefStockCategory = cat);
    initCategoryList();
  }

  clearCryptoList() {
    if (mounted) {
      setState(() {
        items = [];
      });
    }
  }

  Future getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString("currency") != null ? currencyFromText(prefs.getString("currency")!) : SelectedCurrency.usd;
  }

  Future initCategoryList() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    getCurrency();

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      items = await fetchProvider.fetchByCategory(prefStockCategory.name);
      if (mounted) {
        setState(() => isLoading = false);
        setState(() => isLoadingCompleteData = true);
      }
      await fetchProvider.fetchCompleteCategoryData(items, currency.asString);

      if (mounted) {
        setState(() => isLoadingCompleteData = false);
      }
      internetConnection = true;
    } else {
      internetConnection = false;
      if (mounted) {
        setState(() => isLoading = false);
        setState(() => isLoadingCompleteData = false);
      }
    }
  }

  Future initSearchStocks() async {
    if (controller.text.length > 3 && controller.text.length < 25) {
      if (mounted) {
        setState(() => isLoading = true);
      }
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        items = await fetchProvider.fetchSearch(controller.text);

        if (mounted) {
          setState(() {
            isLoading = false;
            isLoadingCompleteData = true;
          });
        }
        await fetchProvider.fetchCompleteSearchData(items, currency.asString);

        if (mounted) {
          setState(() => isLoadingCompleteData = false);
        }
        internetConnection = true;
      } else {
        internetConnection = false;
        if (mounted) {
          setState(() => isLoading = false);
          setState(() => isLoadingCompleteData = false);
        }
      }
    }
  }
}

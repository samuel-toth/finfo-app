import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:thesis_app/models/search_models.dart';
import 'package:thesis_app/utils/db/stock_db.dart';
import 'package:thesis_app/models/portfolio_models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thesis_app/utils/providers/fetch_provider.dart';

class AddStockPortfolio extends StatefulWidget {
  const AddStockPortfolio({Key? key}) : super(key: key);

  @override
  State<AddStockPortfolio> createState() => _AddStockPortfolioState();
}

class _AddStockPortfolioState extends State<AddStockPortfolio> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController symbolController;
  late TextEditingController valueController;
  bool isFavourite = false;
  final FetchProvider fetchProvider = FetchProvider();
  String selectedStockSymbol = "";
  bool internetConnection = true;
  List<String> fetchedSymbols = [];

  @override
  void initState() {
    super.initState();
    checkConnection();

    nameController = TextEditingController();
    symbolController = TextEditingController();
    valueController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.addNewStock)),
        body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: buildAddForm(),
        ));
  }

  Widget buildAddForm() {
    return Form(
      key: _key,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.enterName;
                } else if (value.length > 25) {
                  return AppLocalizations.of(context)!.validateNameLength;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.nameStock,
                filled: true,
                isDense: true,
              ),
              controller: nameController,
            ),
            const SizedBox(
              height: 12,
            ),
            !internetConnection
                ? TextFormField(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.noInternet,
                      filled: true,
                      isDense: true,
                    ),
                    enabled: false,
                  )
                : TypeAheadFormField<SearchStock?>(
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: symbolController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.searchAvailableStocks,
                          filled: true,
                          isDense: true,
                        )),
                    suggestionsCallback: (pattern) async {
                      return loadSearchResult(pattern);
                    },
                    hideOnError: true,
                    itemBuilder: (context, SearchStock? stock) {
                      return ListTile(title: Text(stock!.name));
                    },
                    hideOnEmpty: true,
                    hideOnLoading: true,
                    onSuggestionSelected: (stock) {
                      selectedStockSymbol = stock!.symbol;
                      symbolController.text = stock.symbol;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)!.selectStock;
                      }
                      if (!fetchedSymbols.any((element) => element.toLowerCase() == value.toLowerCase())) {
                        return AppLocalizations.of(context)!.selectSupportedStock;
                      }
                    },
                  ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.amountStock,
                filled: true,
                isDense: true,
              ),
              controller: valueController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty || num.tryParse(value.replaceAll(",", ".")) == null || num.tryParse(value.replaceAll(",", "."))! < 0) {
                  return AppLocalizations.of(context)!.enterValidNumber;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(AppLocalizations.of(context)!.addFavourites, style: const TextStyle(fontSize: 18)),
                Switch(
                  value: isFavourite,
                  onChanged: (bool value) {
                    setState(() {
                      isFavourite = value;
                    });
                  },
                )
              ]),
            ),
            const SizedBox(
              height: 16,
            ),
            TextButton(
              onPressed: () {
                if (_key.currentState!.validate()) {
                  addStock();
                  Navigator.of(context).pop();
                }
              },
              child: Text(AppLocalizations.of(context)!.addPortfolio),
            ),
          ],
        ),
      ),
    );
  }

  Future addStock() async {
    double parsedNumber = double.parse(valueController.text.replaceAll(",", "."));
    final stock = PortfolioStock(name: nameController.text, symbol: selectedStockSymbol, amount: parsedNumber, isFavourite: isFavourite);
    await StockDatabase.instance.createStock(stock);
  }

  Future<List<SearchStock>> loadSearchResult(String keyword) async {
    if (keyword == "") {
      return [];
    }
    List<SearchStock> fetchedItems = await fetchProvider.fetchSearch(keyword);

    for (var item in fetchedItems) {
      fetchedSymbols.add(item.symbol);
    }

    return fetchedItems;
  }

  Future checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      internetConnection = true;
    } else {
      internetConnection = false;
    }
  }
}

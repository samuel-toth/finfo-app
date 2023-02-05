import 'package:coingecko_dart/dataClasses/coins/FullCoin.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:thesis_app/utils/db/crypto_db.dart';
import 'package:thesis_app/models/portfolio_models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thesis_app/utils/providers/coingecko_provider.dart';

class AddCryptoPortfolio extends StatefulWidget {
  const AddCryptoPortfolio({Key? key}) : super(key: key);

  @override
  State<AddCryptoPortfolio> createState() => _AddCryptoPortfolioState();
}

class _AddCryptoPortfolioState extends State<AddCryptoPortfolio> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  late List<FullCoin> availableCryptos;
  bool isLoading = false;

  late TextEditingController nameController;
  late TextEditingController amountController;
  late TextEditingController walletController;
  late TextEditingController symbolController;
  String selectedCryptoSymbol = "";
  String selectedCryptoId = "";
  bool internetConnection = true;

  bool isFavourite = false;
  final CoinGeckoProvider coinProvider = CoinGeckoProvider();
  List<String> fetchedSymbols = [];

  @override
  void initState() {
    super.initState();

    checkConnection();

    nameController = TextEditingController();
    amountController = TextEditingController();
    walletController = TextEditingController();
    symbolController = TextEditingController();
    loadCryptos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.addNewCrypto)),
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
                labelText: AppLocalizations.of(context)!.nameCryptocurrency,
                filled: true,
                isDense: true,
              ),
              controller: nameController,
              keyboardType: TextInputType.emailAddress,
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
                : isLoading
                    ? TextFormField(
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.loading,
                          filled: true,
                          isDense: true,
                        ),
                        enabled: false,
                      )
                    : TypeAheadFormField<FullCoin?>(
                        textFieldConfiguration: TextFieldConfiguration(
                            controller: symbolController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.searchAvailableCryptos,
                              filled: true,
                              isDense: true,
                            )),
                        hideOnError: true,
                        suggestionsCallback: (pattern) {
                          var callbackList = availableCryptos
                              .where((element) => element.name.toLowerCase().contains(pattern.toLowerCase()) || element.symbol.contains(pattern.toLowerCase()));
                          return callbackList;
                        },
                        itemBuilder: (context, FullCoin? stock) {
                          return ListTile(title: Text(stock!.name));
                        },
                        hideOnEmpty: true,
                        hideOnLoading: true,
                        onSuggestionSelected: (stock) {
                          selectedCryptoSymbol = stock!.symbol;
                          selectedCryptoId = stock.id;
                          symbolController.text = stock.name;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.selectCrypto;
                          }
                          if (!availableCryptos.any((element) => element.symbol.toLowerCase() == selectedCryptoSymbol.toLowerCase())) {
                            return AppLocalizations.of(context)!.selectSupportedCrypto;
                          }
                        },
                      ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.amountCryptocurrency,
                filled: true,
                isDense: true,
              ),
              controller: amountController,
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
            TextFormField(
              validator: (value) {
                if (value == null) {
                  return null;
                }
                if (value == "") {
                  return null;
                }
                if (value.length < 25 || value.length > 35) {
                  return AppLocalizations.of(context)!.validateWalletNumber;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.cryptoWalletOptional,
                filled: true,
                isDense: true,
              ),
              controller: walletController,
              keyboardType: TextInputType.text,
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
                  addCrypto();
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

  Future addCrypto() async {
    double parsedNumber = double.parse(amountController.text.replaceAll(",", "."));
    final crypto = PortfolioCrypto(
        name: nameController.text,
        symbol: selectedCryptoSymbol,
        amount: parsedNumber,
        isFavourite: isFavourite,
        walletNumber: walletController.text,
        coinGeckoId: selectedCryptoId);
    await CryptoDatabase.instance.createCrypto(crypto);
  }

  Future loadCryptos() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      availableCryptos = await coinProvider.fetchListFullCoins();

      internetConnection = true;
    } else {
      internetConnection = false;
    }
    if (mounted) {
      setState(() => isLoading = false);
    }
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

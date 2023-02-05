import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesis_app/utils/components/drop_down_menus/settings_currency_dropdown.dart';
import 'package:thesis_app/utils/components/drop_down_menus/settings_news_dropdown.dart';
import 'package:thesis_app/utils/db/crypto_db.dart';
import 'package:thesis_app/utils/db/crypto_history_db.dart';
import 'package:thesis_app/utils/db/stock_db.dart';
import 'package:thesis_app/utils/db/stock_history_db.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thesis_app/utils/enums.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late SelectedCurrency prefCurrency;
  late NewsCategory prefNewsCategory;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getPreferencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: Container(
        padding: const EdgeInsets.all(5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.chooseCurrency + ":",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  isLoading == true
                      ? Text(AppLocalizations.of(context)!.loading)
                      : SettingCurrencyDropdownMenu(selectedCurrency: prefCurrency, update: changeDefaultCurrency)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.chooseNews + ":",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  isLoading == true
                      ? Text(AppLocalizations.of(context)!.loading)
                      : SettingsNewsDropdownMenu(selectedCategory: prefNewsCategory, update: changeNewsCategory)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () async {
                      await CryptoDatabase.instance.deleteDatabase();
                      await CryptoHistoryDatabase.instance.deleteDatabase();
                    },
                    child: Text(AppLocalizations.of(context)!.deleteAllCryptos)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () async {
                      await StockDatabase.instance.deleteDatabase();
                      await StockHistoryDatabase.instance.deleteDatabase();
                    },
                    child: Text(AppLocalizations.of(context)!.deleteAllStocks)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getPreferencies() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefCurrency = prefs.getString("currency") != null ? currencyFromText(prefs.getString("currency")!) : SelectedCurrency.usd;
    prefNewsCategory = newsCategoryFromText(prefs.getString("newsCategory") ?? "business");

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  changeDefaultCurrency(SelectedCurrency currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('currency', currency.asString);
    if (mounted) {
      setState(() => prefCurrency = currency);
    }
  }

  changeNewsCategory(NewsCategory category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('newsCategory', category.name);
    if (mounted) {
      setState(() => prefNewsCategory = category);
    }
  }
}

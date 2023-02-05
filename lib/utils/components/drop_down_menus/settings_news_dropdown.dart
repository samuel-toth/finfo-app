import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thesis_app/utils/enums.dart';

class SettingsNewsDropdownMenu extends StatelessWidget {
  final NewsCategory selectedCategory;
  final ValueChanged<NewsCategory> update;
  const SettingsNewsDropdownMenu({Key? key, required this.selectedCategory, required this.update}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var translations = [
      AppLocalizations.of(context)!.business,
      AppLocalizations.of(context)!.cryptos,
      AppLocalizations.of(context)!.stockMarket,
      AppLocalizations.of(context)!.technology,
    ];
    return DropdownButton<NewsCategory>(
      value: selectedCategory,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 16,
      iconEnabledColor: Theme.of(context).colorScheme.secondary,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Theme.of(context).primaryColor,
      ),
      onChanged: (NewsCategory? newValue) {
        update(newValue!);
      },
      items: <NewsCategory>[NewsCategory.business, NewsCategory.cryptocurrencies, NewsCategory.stockMarket, NewsCategory.technology]
          .map<DropdownMenuItem<NewsCategory>>((NewsCategory value) {
        return DropdownMenuItem<NewsCategory>(
          value: value,
          child: Text(translations[value.index]),
        );
      }).toList(),
    );
  }
}

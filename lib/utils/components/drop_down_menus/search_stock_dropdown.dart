import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thesis_app/utils/enums.dart';

class SearchCategoryDropdownMenu extends StatelessWidget {
  final StockListCategory prefStockCategory;
  final ValueChanged<StockListCategory> update;
  const SearchCategoryDropdownMenu({
    Key? key,
    required this.prefStockCategory,
    required this.update,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var translations = [
      AppLocalizations.of(context)!.mostActive,
      AppLocalizations.of(context)!.gainers,
      AppLocalizations.of(context)!.losers,
    ];
    return DropdownButton<StockListCategory>(
      value: prefStockCategory,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 16,
      iconEnabledColor: Theme.of(context).colorScheme.secondary,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Theme.of(context).primaryColor,
      ),
      onChanged: (StockListCategory? newValue) {
        update(newValue!);
      },
      items: <StockListCategory>[StockListCategory.mostactive, StockListCategory.gainers, StockListCategory.losers]
          .map<DropdownMenuItem<StockListCategory>>((StockListCategory value) {
        return DropdownMenuItem<StockListCategory>(
          value: value,
          child: Text(translations[value.index]),
        );
      }).toList(),
    );
  }
}

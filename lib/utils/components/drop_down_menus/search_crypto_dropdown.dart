import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thesis_app/utils/enums.dart';

class SearchSortDropdownMenu extends StatelessWidget {
  final SelectedSort selectedSort;
  final ValueChanged<SelectedSort> update;
  const SearchSortDropdownMenu({Key? key, required this.selectedSort, required this.update}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var translations = [
      AppLocalizations.of(context)!.marketRank,
      AppLocalizations.of(context)!.highestPrice,
      AppLocalizations.of(context)!.lowestPrice,
      AppLocalizations.of(context)!.highestChange,
      AppLocalizations.of(context)!.highestLose
    ];
    return DropdownButton<SelectedSort>(
      value: selectedSort,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 16,
      iconEnabledColor: Theme.of(context).colorScheme.secondary,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Theme.of(context).primaryColor,
      ),
      onChanged: (SelectedSort? newValue) {
        update(newValue!);
      },
      items: <SelectedSort>[SelectedSort.marketRank, SelectedSort.highestPrice, SelectedSort.lowestPrice, SelectedSort.highestChange, SelectedSort.lowestChange]
          .map<DropdownMenuItem<SelectedSort>>((SelectedSort value) {
        return DropdownMenuItem<SelectedSort>(
          value: value,
          child: Text(translations[value.index]),
        );
      }).toList(),
    );
  }
}

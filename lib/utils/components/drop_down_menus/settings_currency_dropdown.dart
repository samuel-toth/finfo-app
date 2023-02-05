import 'package:flutter/material.dart';
import 'package:thesis_app/utils/enums.dart';

class SettingCurrencyDropdownMenu extends StatelessWidget {
  final SelectedCurrency selectedCurrency;
  final ValueChanged<SelectedCurrency> update;
  const SettingCurrencyDropdownMenu({Key? key, required this.selectedCurrency, required this.update}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<SelectedCurrency>(
      value: selectedCurrency,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 16,
      iconEnabledColor: Theme.of(context).colorScheme.secondary,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Theme.of(context).primaryColor,
      ),
      onChanged: (SelectedCurrency? newValue) {
        update(newValue!);
      },
      items: <SelectedCurrency>[SelectedCurrency.usd, SelectedCurrency.eur, SelectedCurrency.czk]
          .map<DropdownMenuItem<SelectedCurrency>>((SelectedCurrency value) {
        return DropdownMenuItem<SelectedCurrency>(
          value: value,
          child: Text(value.asString),
        );
      }).toList(),
    );
  }
}

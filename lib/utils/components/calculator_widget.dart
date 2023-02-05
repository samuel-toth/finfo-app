import 'package:flutter/material.dart';
import 'package:thesis_app/utils/enums.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalculatorCard extends StatelessWidget {
  CalculatorCard({Key? key, required this.pricePerShare, required this.symbol, required this.currency}) : super(key: key);

  final double pricePerShare;
  final String symbol;
  final SelectedCurrency currency;
  final sharesController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.exchange,
                    style: const TextStyle(fontSize: 25),
                  ),
                ],
              ),
              TextField(
                onChanged: (String value) {
                  if (value.isEmpty) {
                    priceController.text = "";
                  } else {
                    priceController.text = double.tryParse(value.replaceAll(",", ".")) != null
                        ? (double.parse(value.replaceAll(",", ".")) * pricePerShare).toStringAsFixed(2)
                        : "";
                  }
                },
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller: sharesController,
                decoration: InputDecoration(hintText: AppLocalizations.of(context)!.amountOf, suffixText: symbol.toUpperCase()),
              ),
              TextField(
                onChanged: (String value) {
                  if (value.isEmpty) {
                    sharesController.text = "";
                  } else {
                    sharesController.text = double.tryParse(value.replaceAll(",", ".")) != null
                        ? (double.parse(value.replaceAll(",", ".")) / pricePerShare).toStringAsFixed(2)
                        : "";
                  }
                },
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller: priceController,
                decoration: InputDecoration(hintText: AppLocalizations.of(context)!.price, suffixText: currency.symbol),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

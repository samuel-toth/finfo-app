import 'package:flutter/material.dart';
import 'package:thesis_app/models/search_models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thesis_app/utils/components/helper.dart';
import 'package:thesis_app/utils/enums.dart';

class SearchDetailStockCard extends StatelessWidget {
  final SearchStock passedStock;
  final SelectedCurrency passedCurrency;
  const SearchDetailStockCard({Key? key, required this.passedStock, required this.passedCurrency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.price,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      currencyFormatter(passedStock.latestPrice!, passedCurrency.asString),
                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 30, color: Colors.blue),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        "${passedStock.percentageChange1d!.toStringAsFixed(2)}% 1d",
                        style: passedStock.percentageChange1d! < 0
                            ? const TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.red)
                            : const TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.companyStatistics, style: const TextStyle(fontSize: 25)),
              ],
            ),
            buildRow(AppLocalizations.of(context)!.ceo, passedStock.ceo ?? "-", const Icon(Icons.insights)),
            buildRow(AppLocalizations.of(context)!.employees, "${passedStock.employees ?? "-"}", const Icon(Icons.pie_chart)),
            buildRow(AppLocalizations.of(context)!.sector, passedStock.sector ?? "-", const Icon(Icons.account_balance)),
            buildRow(AppLocalizations.of(context)!.stockMarket, passedStock.exchange ?? "-", const Icon(Icons.trending_up)),
          ],
        ),
      ),
    );
  }

  buildRow(String text, String value, Icon icon) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: icon,
        ),
        Text(text, style: const TextStyle(fontSize: 18)),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 18), textAlign: TextAlign.end),
        ),
      ],
    );
  }
}

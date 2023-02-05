import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thesis_app/models/search_models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thesis_app/utils/components/helper.dart';
import 'package:thesis_app/utils/enums.dart';

class SearchDetailCryptoCard extends StatelessWidget {
  final SearchCrypto passedCrypto;
  final SelectedCurrency passedCurrency;
  const SearchDetailCryptoCard({Key? key, required this.passedCrypto, required this.passedCurrency}) : super(key: key);

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
                      currencyFormatter(passedCrypto.latestPrice!, passedCurrency.asString),
                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 30, color: Colors.blue),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        "${passedCrypto.percentageChange1d!.toStringAsFixed(2)}% 1d",
                        style: passedCrypto.percentageChange1d! < 0
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
                Text(AppLocalizations.of(context)!.marketStatistics, style: Theme.of(context).textTheme.headline2),
              ],
            ),
            buildRow(AppLocalizations.of(context)!.marketCapRank, "${passedCrypto.marketCapRank}", const Icon(Icons.leaderboard)),
            buildRow(AppLocalizations.of(context)!.marketCap, NumberFormat.compact().format(passedCrypto.marketCap), const Icon(Icons.business)),
            buildRow(AppLocalizations.of(context)!.circulatingSupply, NumberFormat.compact().format(passedCrypto.circulatingSupply), const Icon(Icons.sync)),
            buildRow(AppLocalizations.of(context)!.maxSupply, NumberFormat.compact().format(passedCrypto.maxSupply), const Icon(Icons.account_balance)),
            buildRow(
                AppLocalizations.of(context)!.allTimeHigh, currencyFormatter(passedCrypto.athPrice!, passedCurrency.asString), const Icon(Icons.trending_up)),
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

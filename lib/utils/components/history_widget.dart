import 'package:flutter/material.dart';
import 'package:thesis_app/models/portfolio_records_models.dart';
import 'package:thesis_app/utils/components/helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryListView extends StatelessWidget {
  final List<PortfolioInvestmentRecord> history;
  final String symbol;
  const HistoryListView({Key? key, required this.history, required this.symbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return history.isNotEmpty
        ? ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "${history[index].amount} ${symbol.toUpperCase()} ${AppLocalizations.of(context)!.at} ${formatDateTime(history[index].date)}",
                  style: const TextStyle(fontSize: 17),
                )
              ]);
            },
          )
        : Text(AppLocalizations.of(context)!.noHistory);
  }
}

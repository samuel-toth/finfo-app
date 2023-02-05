import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thesis_app/models/portfolio_models.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thesis_app/utils/components/helper.dart';
import 'package:thesis_app/utils/enums.dart';

class PortfolioInvestmentCard extends StatelessWidget {
  final PortfolioInvestment investment;
  final SelectedCurrency currency;
  final bool isLoading;
  const PortfolioInvestmentCard({
    Key? key,
    required this.investment,
    required this.currency,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Padding(padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0), child: investmentImage(investment, isLoading)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                          child: Text(
                            investment.name,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                              child: Text(
                                investment.symbol.toUpperCase(),
                                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                              child: Text(
                                "${investment.amount}",
                                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                child: SizedBox(
                                  width: 100,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      getInvestmentPrice(investment, currency),
                                      style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.blue),
                                    ),
                                  ),
                                )),
                            Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0), child: investmentPercentageChange(context, investment, isLoading)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  investmentPercentageChange(BuildContext context, PortfolioInvestment investment, bool isLoading) {
    return isLoading
        ? Text(AppLocalizations.of(context)!.loading)
        : Text("${investment.percentageChange1d!.toStringAsFixed(2)}% 1d",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: investment.percentageChange1d! < 0 ? Colors.red : Colors.green,
            ));
  }

  investmentImage(PortfolioInvestment investment, bool isLoading) {
    return isLoading
        ? const CircularProgressIndicator()
        : CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 25,
            child: ClipOval(
              child: CachedNetworkImage(
                key: UniqueKey(),
                placeholder: (context, url) => const CircularProgressIndicator(),
                imageUrl: investment.iconUrl!,
                errorWidget: (context, url, error) => Container(color: Colors.black, child: const Icon(Icons.error, color: Colors.red)),
              ),
            ),
          );
  }
}

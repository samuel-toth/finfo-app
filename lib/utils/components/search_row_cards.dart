import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thesis_app/models/search_models.dart';
import 'package:thesis_app/utils/components/helper.dart';
import 'package:thesis_app/utils/enums.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchCryptoRowCard extends StatelessWidget {
  final SearchCrypto crypto;
  final SelectedCurrency currency;
  const SearchCryptoRowCard({Key? key, required this.crypto, required this.currency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 25,
                child: ClipOval(
                  child: CachedNetworkImage(
                    key: UniqueKey(),
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    imageUrl: crypto.iconUrl!,
                    errorWidget: (context, url, error) => const Icon(
                      Icons.business,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              crypto.name,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                            Text(
                              crypto.symbol.toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              currencyFormatter(crypto.latestPrice!, currency.asString),
                              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20, color: Colors.blue),
                            ),
                          ),
                          Text(
                            "${crypto.percentageChange1d!.toStringAsFixed(2)}%",
                            style: TextStyle(color: crypto.percentageChange1d! < 0 ? Colors.red : Colors.green, fontWeight: FontWeight.w600, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class SearchStockRowCard extends StatelessWidget {
  final SearchStock stock;
  final SelectedCurrency currency;
  final bool isLoading;
  const SearchStockRowCard({Key? key, required this.stock, required this.currency, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 25,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : stock.iconUrl == null || stock.iconUrl == ""
                        ? const Icon(
                            Icons.business,
                            size: 30,
                          )
                        : ClipOval(
                            child: CachedNetworkImage(
                              key: UniqueKey(),
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              imageUrl: stock.iconUrl!,
                              errorWidget: (context, url, error) => const Icon(
                                Icons.business,
                                size: 30,
                              ),
                            ),
                          ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stock.name,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                            Text(
                              stock.symbol.toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              isLoading && stock.latestPrice != null ? " " : currencyFormatter(stock.latestPrice!, currency.asString),
                              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20, color: Colors.blue),
                            ),
                          ),
                          Text(
                            isLoading ? " " : "${stock.percentageChange1d!.toStringAsFixed(2)}%",
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

searchStockRowCard(BuildContext context, SearchStock stock, SelectedCurrency currency, bool isLoading) {
  return Card(
      elevation: 8,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            ClipOval(
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 25,
                child: stock.iconUrl == null || stock.iconUrl == ""
                    ? const Icon(Icons.business)
                    : CachedNetworkImage(
                        key: UniqueKey(),
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        imageUrl: stock.iconUrl!,
                        errorWidget: (context, url, error) => const Icon(Icons.business),
                      ),
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stock.name,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                          Text(
                            stock.symbol.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            isLoading || stock.latestPrice == null
                                ? AppLocalizations.of(context)!.loading
                                : currencyFormatter(stock.latestPrice!, currency.asString),
                            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20, color: Colors.blue),
                          ),
                        ),
                        Text(
                          isLoading || stock.percentageChange1d == null ? " " : "${stock.percentageChange1d!.toStringAsFixed(2)}%",
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
}

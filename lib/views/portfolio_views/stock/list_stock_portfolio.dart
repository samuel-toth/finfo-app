import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesis_app/models/portfolio_models.dart';
import 'package:thesis_app/utils/components/portfolio_card_widget.dart';
import 'package:thesis_app/utils/enums.dart';
import 'package:thesis_app/utils/providers/fetch_provider.dart';
import 'package:thesis_app/views/portfolio_views/stock/add_stock_portfolio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thesis_app/views/portfolio_views/stock/detail_stock_portfolio.dart';
import 'package:thesis_app/utils/db/stock_db.dart';

class StockPorfolio extends StatefulWidget {
  const StockPorfolio({Key? key}) : super(key: key);

  @override
  State<StockPorfolio> createState() => _StockPorfolioState();
}

class _StockPorfolioState extends State<StockPorfolio> {
  late List<PortfolioStock> stocks;
  bool isLoading = false;
  bool isLoadingCompleteData = true;
  final FetchProvider fetchProvider = FetchProvider();

  late SelectedCurrency currency;

  @override
  void initState() {
    super.initState();
    loadStocks();
    getCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: loadStocks,
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : stocks.isEmpty
                  ? Text(AppLocalizations.of(context)!.noInvestment)
                  : buildNotes(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddStockPortfolio()),
          );
          loadStocks();
        },
      ),
    );
  }

  Widget buildNotes(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: stocks.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StockPortfolioDetail(
                            passedStock: stocks[index],
                            currency: currency,
                          )),
                );
                loadStocks();
              },
              child: PortfolioInvestmentCard(investment: stocks[index], currency: currency, isLoading: isLoadingCompleteData));
        },
      );

  @override
  void dispose() {
    super.dispose();
  }

  Future getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString("currency") != null ? currencyFromText(prefs.getString("currency")!) : SelectedCurrency.usd;
  }

  Future loadStocks() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    getCurrency();

    stocks = await StockDatabase.instance.readAllStocks();
    if (mounted) {
      setState(() => isLoading = false);
    }
    if (mounted) {
      setState(() => isLoadingCompleteData = true);
    }

    await fetchProvider.fetchCompletePortfolioStockData(stocks);

    if (mounted) {
      setState(() => isLoadingCompleteData = false);
    }
  }
}

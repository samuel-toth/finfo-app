import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesis_app/utils/db/crypto_db.dart';
import 'package:thesis_app/models/portfolio_models.dart';
import 'package:thesis_app/utils/enums.dart';
import 'package:thesis_app/utils/providers/fetch_provider.dart';
import 'package:thesis_app/views/portfolio_views/crypto/add_crypto_portfolio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thesis_app/views/portfolio_views/crypto/detail_crypto_portfolio.dart';
import 'package:thesis_app/utils/components/portfolio_card_widget.dart';

class CryptoPortfolio extends StatefulWidget {
  const CryptoPortfolio({Key? key}) : super(key: key);

  @override
  State<CryptoPortfolio> createState() => _CryptoPortfolioState();
}

class _CryptoPortfolioState extends State<CryptoPortfolio> {
  late List<PortfolioCrypto> cryptos;
  bool isLoading = false;
  bool isLoadingCompleteData = true;
  final FetchProvider fetchProvider = FetchProvider();
  late SelectedCurrency currency;

  @override
  void initState() {
    super.initState();
    loadCryptos();
    getCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: loadCryptos,
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : cryptos.isEmpty
                  ? Text(AppLocalizations.of(context)!.noInvestment)
                  : buildNotes(),
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
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCryptoPortfolio()),
          );

          loadCryptos();
        },
      ),
    );
  }

  Widget buildNotes() => ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: cryptos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CryptoPortfolioDetail(
                            passedCrypto: cryptos[index],
                            currency: currency,
                          )),
                );
                loadCryptos();
              },
              child: PortfolioInvestmentCard(investment: cryptos[index], currency: currency, isLoading: isLoadingCompleteData));
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

  Future loadCryptos() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    cryptos = await CryptoDatabase.instance.readAllCryptos();
    if (mounted) {
      setState(() => isLoading = false);
    }
    if (mounted) {
      setState(() => isLoadingCompleteData = true);
    }
    await fetchProvider.fetchCompletePortfolioCryptoData(cryptos);
    if (mounted) {
      setState(() => isLoadingCompleteData = false);
    }
  }
}

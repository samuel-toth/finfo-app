import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thesis_app/models/news_model.dart';
import 'package:thesis_app/models/portfolio_models.dart';
import 'package:thesis_app/utils/components/article_row_widget.dart';
import 'package:thesis_app/utils/components/helper.dart';
import 'package:thesis_app/utils/components/home_favourites_widget.dart';
import 'package:thesis_app/utils/db/crypto_db.dart';
import 'package:thesis_app/utils/db/stock_db.dart';
import 'package:thesis_app/utils/enums.dart';
import 'package:thesis_app/utils/providers/api_provider.dart';
import 'package:thesis_app/views/settings_view.dart';
import 'package:connectivity/connectivity.dart';

class HomeDetail extends StatefulWidget {
  const HomeDetail({Key? key}) : super(key: key);

  @override
  State<HomeDetail> createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => false;
  final ApiProvider apiProvider = ApiProvider();

  late List<PortfolioCrypto> favouriteCryptos;
  late List<PortfolioStock> favouriteStocks;
  List<Article> articles = [];

  bool isLoading = false;
  bool isLoadingCompleteData = true;
  bool isLoadingArticles = true;
  bool internetConnection = true;
  String totalValueFormatted = "";

  late SelectedCurrency currency;
  NewsCategory prefNewsCategory = NewsCategory.business;

  @override
  void initState() {
    super.initState();
    loadFavouriteAssets();
    loadArticles();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.home,
            style: Theme.of(context).textTheme.headline1,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsView()));
                loadFavouriteAssets();
              },
            ),
          ],
        ),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.balance,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(totalValueFormatted,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            )),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 3,
                ),
                buildFavouriteSection(),
                const Divider(
                  thickness: 1,
                ),
                buildArticlesSection()
              ],
            ),
          ),
        ));
  }

  buildArticlesSection() {
    return Row(
      children: [
        Expanded(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.followedNews,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            !internetConnection
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.signal_wifi_off, size: 30, color: Colors.grey),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.signal_cellular_off, size: 30, color: Colors.grey)
                      ],
                    ),
                  )
                : isLoadingArticles
                    ? const CircularProgressIndicator()
                    : Padding(padding: const EdgeInsets.only(top: 10), child: ArticlesRowsListView(articles: articles)),
          ],
        ))
      ],
    );
  }

  buildFavouriteSection() {
    return Row(
      children: [
        Expanded(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.pinnedInvestments,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            isLoading
                ? const CircularProgressIndicator()
                : FavouritesWidget(
                    favouriteCryptos: favouriteCryptos,
                    favouriteStocks: favouriteStocks,
                    currency: currency,
                    isLoading: isLoadingCompleteData,
                  ),
          ],
        )),
      ],
    );
  }

  Future loadFavouriteAssets() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    favouriteCryptos = await CryptoDatabase.instance.readFavouriteCryptos();
    favouriteStocks = await StockDatabase.instance.readFavouriteStocks();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString("currency") != null ? currencyFromText(prefs.getString("currency")!) : SelectedCurrency.usd;

    totalValueFormatted = await currencyFormatter(await getPorfolioSum(currency), currency.asString);
    if (mounted) {
      setState(() => isLoading = false);
    }
    if (mounted) {
      setState(() => isLoadingCompleteData = true);
    }
    if (mounted) {
      setState(() => isLoadingCompleteData = false);
    }
  }

  Future loadArticles() async {
    if (mounted) {
      setState(() => isLoadingArticles = true);
    }

    articles = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefNewsCategory = newsCategoryFromText(prefs.getString("newsCategory") ?? "business");
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      var temp = await apiProvider.fetchNewsAPI(prefNewsCategory.name, 3, 1);
      for (var i = 0; i < temp["articles"].length; i++) {
        articles.add(Article.fromJson(temp["articles"][i]));
      }
      internetConnection = true;
    } else {
      internetConnection = false;
    }

    if (mounted) {
      setState(() => isLoadingArticles = false);
    }
  }
}

Future getPrefNewsCategory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var prefNewsCategory = newsCategoryFromText(prefs.getString("newsCategory") ?? "business");
  return prefNewsCategory;
}

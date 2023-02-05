import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thesis_app/models/news_model.dart';
import 'package:thesis_app/utils/components/article_card_widget.dart';
import 'package:thesis_app/utils/enums.dart';
import 'package:thesis_app/utils/providers/api_provider.dart';

class NewsDetail extends StatefulWidget {
  const NewsDetail({Key? key}) : super(key: key);

  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<Article> articles = [];
  bool isLoading = false;
  NewsCategory selectedCat = NewsCategory.business;
  String selectedTag = "business";
  final ApiProvider apiProvider = ApiProvider();
  final controller = TextEditingController();
  int pageNumber = 1;
  bool internetConnection = true;

  @override
  void initState() {
    super.initState();
    loadArticles();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.news,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildPagesButton(false),
            buildPagesButton(true),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.clear();
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      selectedTag = controller.text.toLowerCase().replaceAll(" ", "");
                      loadArticles();
                    },
                  ),
                  hintText: AppLocalizations.of(context)!.searchWord,
                ),
              ),
            ),
          ),
          buildCategoryRow(),
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
              : isLoading
                  ? const CircularProgressIndicator()
                  : Flexible(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            return ArticleCard(article: articles[index]);
                          })),
        ],
      ),
    );
  }

  buildCategoryRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            buildCategoryButton(NewsCategory.business, AppLocalizations.of(context)!.business),
            buildCategoryButton(NewsCategory.stockMarket, AppLocalizations.of(context)!.stockMarket),
            buildCategoryButton(NewsCategory.cryptocurrencies, AppLocalizations.of(context)!.cryptos),
            buildCategoryButton(NewsCategory.technology, AppLocalizations.of(context)!.technology),
          ],
        ),
      ),
    );
  }

  buildCategoryButton(NewsCategory newsCat, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 40,
        child: TextButton(
          child: Text(text),
          onPressed: () async {
            selectedCat = newsCat;
            selectedTag = selectedCat.name;
            loadArticles();
          },
        ),
      ),
    );
  }

  buildPagesButton(bool next) {
    return FloatingActionButton(
      heroTag: null,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.primary,
      onPressed: () {
        if (next) {
          pageNumber = pageNumber + 1;
          loadArticles();
        } else {
          if (pageNumber > 1) {
            pageNumber = pageNumber - 1;
            loadArticles();
          }
        }
      },
      child: Icon(next ? Icons.arrow_forward : Icons.arrow_back),
    );
  }

  Future loadArticles() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      articles = [];

      var temp = await apiProvider.fetchNewsAPI(selectedTag, 10, pageNumber);
      for (var i = 0; i < temp["articles"].length; i++) {
        articles.add(Article.fromJson(temp["articles"][i]));
      }
      internetConnection = true;
    } else {
      internetConnection = false;
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }
}

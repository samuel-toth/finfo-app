import 'package:flutter/material.dart';
import 'package:thesis_app/models/news_model.dart';
import 'package:thesis_app/utils/components/helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArticlesRowsListView extends StatelessWidget {
  const ArticlesRowsListView({
    Key? key,
    required this.articles,
  }) : super(key: key);

  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) {
      return Text(AppLocalizations.of(context)!.noArticles);
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return ArticleCardRow(article: articles[index]);
      },
    );
  }
}

class ArticleCardRow extends StatelessWidget {
  final Article article;

  const ArticleCardRow({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await canLaunch(article.url!) ? await launch(article.url!) : throw 'Could not open browser';
      },
      child: Card(
        elevation: 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    article.source.name,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    article.publishedAt != null ? "${formatDateTime(DateTime.parse(article.publishedAt!))}" : "",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                article.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

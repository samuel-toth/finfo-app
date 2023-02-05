import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:thesis_app/views/home_views/home_detail.dart';
import 'package:thesis_app/views/news_views/news_detail.dart';
import 'package:thesis_app/views/portfolio_views/portfolio_detail.dart';
import 'package:thesis_app/views/search_views/search_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomBarWidget extends StatefulWidget {
  const BottomBarWidget({Key? key}) : super(key: key);

  @override
  State<BottomBarWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<BottomBarWidget> {
  int selectedIndex = 0;
  static final List<Widget> widgetOptions = <Widget>[const HomeDetail(), const PortfolioDetail(), const NewsDetail(), const SearchDetail()];

  late PageController pageController;

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: widgetOptions,
      ),
      bottomNavigationBar: PlatformNavBar(
        material: (_, __) => MaterialNavBarData(
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.primary,
        ),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
            ),
            label: AppLocalizations.of(context)!.home.toUpperCase(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet),
            label: AppLocalizations.of(context)!.portfolio.toUpperCase(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.feed),
            label: AppLocalizations.of(context)!.news.toUpperCase(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: AppLocalizations.of(context)!.search.toUpperCase(),
          )
        ],
        currentIndex: selectedIndex,
        itemChanged: (index) => setState(
          () {
            selectedIndex = index;
            pageController.jumpToPage(selectedIndex);
          },
        ),
      ),
    );
  }
}

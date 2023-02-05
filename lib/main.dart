import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:thesis_app/utils/components/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thesis_app/utils/providers/theme_provider.dart';
import 'views/bottom_bar.dart';
import 'package:catcher/catcher.dart';

main() {
  CatcherOptions debugOptions = CatcherOptions(SilentReportMode(), [
    catcherHandler(),
  ], localizationOptions: [
    LocalizationOptions(
      "sk",
      toastHandlerDescription: "Nastala chyba.",
    ),
    LocalizationOptions(
      "en",
      toastHandlerDescription: "Something wrong happened.",
    )
  ]);

  CatcherOptions releaseOptions = CatcherOptions(SilentReportMode(), [
    catcherHandler(),
  ], localizationOptions: [
    LocalizationOptions("sk", toastHandlerDescription: "Nastala chyba."),
    LocalizationOptions(
      "en",
      toastHandlerDescription: "Something wrong happened.",
    )
  ]);

  Catcher(rootWidget: MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final ThemeProvider themeProvider = ThemeProvider();

  static const String _title = 'Finfo';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Catcher.navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeProvider.lightTheme,
      darkTheme: ThemeProvider.darkTheme,
      title: _title,
      home: const BottomBarWidget(),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('sk', 'SK'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}

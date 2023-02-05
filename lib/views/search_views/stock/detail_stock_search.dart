import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:thesis_app/models/graph_model.dart';
import 'package:thesis_app/models/search_models.dart';
import 'package:thesis_app/utils/components/calculator_widget.dart';
import 'package:thesis_app/utils/components/graph_widget.dart';
import 'package:thesis_app/utils/components/search_stock_card.dart';
import 'package:thesis_app/utils/enums.dart';
import 'package:thesis_app/utils/providers/api_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailStockSearch extends StatefulWidget {
  const DetailStockSearch({Key? key, required this.passedStock, required this.passedCurrency}) : super(key: key);
  final SearchStock passedStock;
  final SelectedCurrency passedCurrency;

  @override
  State<DetailStockSearch> createState() => _DetailStockSearchState();
}

class _DetailStockSearchState extends State<DetailStockSearch> {
  final ApiProvider apiProvider = ApiProvider();

  List<GraphModel> graphDataHourly = [];
  List<GraphModel> graphDataDaily = [];
  List<GraphModel> graphDataToShow = [];

  bool isLoadingGraph = false;
  bool isLoadingData = false;
  bool noGraphHourlyData = false;
  bool noGraphDailyData = false;
  bool internetConnection = true;

  String numberOfDays = "5dm";

  @override
  void initState() {
    super.initState();
    checkConnection();
    loadHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.passedStock.name),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                    : buildGraphRow(),
                Row(
                  children: [
                    Expanded(
                      child: SearchDetailStockCard(
                        passedCurrency: widget.passedCurrency,
                        passedStock: widget.passedStock,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CalculatorCard(
                      pricePerShare: widget.passedStock.latestPrice ?? 0,
                      symbol: widget.passedStock.symbol,
                      currency: widget.passedCurrency,
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  buildGraphRow() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              child: isLoadingGraph
                  ? const Center(child: CircularProgressIndicator())
                  : noGraphHourlyData || noGraphDailyData
                      ? Center(child: Text(AppLocalizations.of(context)!.noGraphData))
                      : Chart(
                          passedData: graphDataToShow,
                          currency: widget.passedCurrency,
                        )),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      graphDataToShow = graphDataHourly.where((element) => element.time.isAfter(DateTime.now().subtract(const Duration(days: 3)))).toList();
                    });
                  },
                  child: const Text(
                    "3D",
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        graphDataToShow = graphDataHourly.where((element) => element.time.isAfter(DateTime.now().subtract(const Duration(days: 10)))).toList();
                      });
                    },
                    child: const Text(
                      "10D",
                    )),
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      graphDataToShow = graphDataHourly;
                    });
                  },
                  child: const Text(
                    "1M",
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        graphDataToShow = graphDataDaily.where((element) => element.time.isAfter(DateTime.now().subtract(const Duration(days: 180)))).toList();
                      });
                    },
                    child: const Text(
                      "6M",
                    )),
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      graphDataToShow = graphDataDaily;
                    });
                  },
                  child: const Text(
                    "1Y",
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Future loadHistoryData() async {
    if (mounted) {
      setState(() => isLoadingGraph = true);
    }
    var resultsHourly = await apiProvider.fetchIexHistoricalMonthPrices(widget.passedStock.symbol);
    var resultsDaily = await apiProvider.fetchIexHistoricalPrices(widget.passedStock.symbol, "1y");

    if (!resultsHourly.isEmpty) {
      for (var record in resultsHourly) {
        var date = "${record["date"]}";
        if (record["minute"] != null) {
          date = date + " ${record["minute"]}";
        }
        if (record["close"] != null) {
          num closePrice = record["close"];
          graphDataHourly.add(GraphModel(DateTime.parse(date), closePrice.toDouble()));
        }
        noGraphHourlyData = false;
      }
    } else {
      noGraphHourlyData = true;
    }
    if (!resultsDaily.isEmpty) {
      for (var record in resultsDaily) {
        var date = "${record["date"]}";
        if (record["minute"] != null) {
          date = date + " ${record["minute"]}";
        }
        if (record["close"] != null) {
          num closePrice = record["close"];
          graphDataDaily.add(GraphModel(DateTime.parse(date), closePrice.toDouble()));
        }
        noGraphDailyData = false;
      }
    } else {
      noGraphDailyData = true;
    }

    graphDataToShow = graphDataHourly;

    if (mounted) {
      setState(() => isLoadingGraph = false);
    }
  }

  Future checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      internetConnection = true;
    } else {
      internetConnection = false;
    }
  }
}

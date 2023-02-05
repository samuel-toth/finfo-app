import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:thesis_app/models/portfolio_models.dart';
import 'package:thesis_app/models/portfolio_records_models.dart';
import 'package:thesis_app/utils/components/helper.dart';
import 'package:thesis_app/utils/components/history_widget.dart';
import 'package:thesis_app/utils/db/stock_db.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thesis_app/utils/db/stock_history_db.dart';
import 'package:thesis_app/utils/enums.dart';

class StockPortfolioDetail extends StatefulWidget {
  final PortfolioStock passedStock;
  final SelectedCurrency currency;
  const StockPortfolioDetail({Key? key, required this.passedStock, required this.currency}) : super(key: key);

  @override
  State<StockPortfolioDetail> createState() => _StockPortfolioDetailState();
}

class _StockPortfolioDetailState extends State<StockPortfolioDetail> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  late List<PortfolioInvestmentRecord> history;
  bool isLoading = false;
  double calculated = 0;
  bool ascending = true;

  late String formattedPrice;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.passedStock.name),
        actions: [
          IconButton(
              onPressed: () async {
                setState(() {
                  widget.passedStock.toggleFavourites();
                });
                await StockDatabase.instance.updateStock(widget.passedStock);
              },
              icon: widget.passedStock.isFavourite
                  ? const Icon(
                      Icons.star,
                      color: Colors.orange,
                    )
                  : const Icon(Icons.star_border, color: Colors.orange))
        ],
      ),
      body: isLoading
          ? const CircularProgressIndicator()
          : SafeArea(
              minimum: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.price,
                                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          isLoading ? AppLocalizations.of(context)!.loading : formattedPrice,
                                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w400, color: Colors.blue),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          child: Text("${widget.passedStock.amount.toStringAsFixed(2)} ${widget.passedStock.symbol.toUpperCase()}"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        displayDialog(context, AppLocalizations.of(context)!.addMoreStock, false);
                                      },
                                      icon: const Icon(Icons.add_circle_outline),
                                      color: Theme.of(context).colorScheme.primary,
                                      iconSize: 100,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          displayDialog(context, AppLocalizations.of(context)!.removeFromStock, true);
                                        },
                                        icon: const Icon(Icons.remove_circle_outline),
                                        color: Theme.of(context).colorScheme.primary,
                                        iconSize: 100)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const Divider(
                    thickness: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!.history,
                          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            setState(() {
                              ascending = !ascending;
                              history = List.from(history.reversed);
                            });
                          },
                          icon: ascending ? const Icon(Icons.arrow_upward) : const Icon(Icons.arrow_downward))
                    ],
                  ),
                  Flexible(child: HistoryListView(history: history, symbol: widget.passedStock.symbol)),
                  TextButton(
                    onPressed: () async {
                      await StockDatabase.instance.deleteStock(widget.passedStock.id!);
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.removeStock),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> displayDialog(BuildContext context, String text, bool subtract) async {
    var convertedPrice = "";
    return showPlatformDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return PlatformAlertDialog(
              title: PlatformText(text),
              content: SizedBox(
                height: 90,
                child: Column(
                  children: [
                    Form(
                      key: _key,
                      child: PlatformTextFormField(
                          maxLength: 15,
                          hintText: "${AppLocalizations.of(context)!.amountOf} ${widget.passedStock.symbol.toUpperCase()}",
                          cupertino: (_, __) => CupertinoTextFormFieldData(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                          onChanged: (text) {
                            setState(() {
                              if (double.tryParse(text.replaceAll(",", ".")) != null) {
                                calculated = getInvestmentPriceAsDouble(widget.passedStock, widget.currency) * double.parse(text.replaceAll(",", "."));
                                convertedPrice = currencyFormatter(calculated, widget.currency.asString);
                                calculated = 0;
                              } else {
                                calculated = 0;
                                convertedPrice = currencyFormatter(calculated, widget.currency.asString);
                              }
                            });
                          },
                          controller: controller,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value == "") {
                              return AppLocalizations.of(context)!.enterAmount;
                            }
                            if (num.tryParse(value.replaceAll(",", ".")) == null) {
                              return AppLocalizations.of(context)!.enterValidNumber;
                            }
                            if (num.tryParse(value.replaceAll(",", "."))! < 0) {
                              return AppLocalizations.of(context)!.enterPositiveNumber;
                            }
                            if (widget.passedStock.amount <= num.parse(value.replaceAll(",", ".")) && subtract) {
                              return AppLocalizations.of(context)!.numberLarger;
                            }
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: PlatformText(
                              convertedPrice,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                PlatformDialogAction(
                  child: PlatformText(AppLocalizations.of(context)!.cancel),
                  onPressed: () => Navigator.pop(context),
                ),
                PlatformDialogAction(
                  child: PlatformText(AppLocalizations.of(context)!.confirm),
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      setState(() {
                        subtract
                            ? widget.passedStock.addShares(-double.parse(controller.text.replaceAll(",", ".")))
                            : widget.passedStock.addShares(double.parse(controller.text.replaceAll(",", ".")));
                      });
                      await StockDatabase.instance.updateStock(widget.passedStock);
                      await StockHistoryDatabase.instance.createRecord(PortfolioInvestmentRecord(
                          foreignId: widget.passedStock.id!,
                          amount: subtract ? -double.parse(controller.text.replaceAll(",", ".")) : double.parse(controller.text.replaceAll(",", ".")),
                          date: DateTime.now()));
                      Navigator.of(context).pop();
                      loadHistory();
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  Future loadHistory() async {
    if (mounted) {
      setState(() => isLoading = true);
    }
    formattedPrice = getInvestmentPrice(widget.passedStock, widget.currency);

    history = await StockHistoryDatabase.instance.readRecordsFor(widget.passedStock.id!);
    if (mounted) {
      setState(() => isLoading = false);
    }
  }
}

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:thesis_app/models/graph_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
// ignore: implementation_imports
import 'package:charts_flutter/src/text_element.dart' as element;
// ignore: implementation_imports
import 'package:charts_flutter/src/text_style.dart' as style;

import 'dart:math';

import 'package:thesis_app/utils/components/helper.dart';
import 'package:thesis_app/utils/enums.dart';

class Chart extends StatelessWidget {
  final List<GraphModel> passedData;
  final SelectedCurrency currency;
  const Chart({Key? key, required this.passedData, required this.currency}) : super(key: key);

  static String pointerValue = "";
  static String pointerValueDate = "";

  @override
  Widget build(BuildContext context) {
    var maxValue = passedData.reduce((current, next) => current.price > next.price ? current : next).price;
    var minValue = passedData.reduce((current, next) => current.price < next.price ? current : next).price;

    return charts.TimeSeriesChart(
      createData(context, passedData),
      animate: false,
      domainAxis: charts.DateTimeAxisSpec(
          showAxisLine: true,
          renderSpec: charts.SmallTickRendererSpec(
              labelStyle: charts.TextStyleSpec(color: charts.ColorUtil.fromDartColor(Theme.of(context).colorScheme.secondaryVariant)),
              lineStyle: charts.LineStyleSpec(color: charts.ColorUtil.fromDartColor(Colors.grey))),
          tickProviderSpec: const charts.AutoDateTimeTickProviderSpec(),
          tickFormatterSpec: const charts.AutoDateTimeTickFormatterSpec(day: charts.TimeFormatterSpec(format: 'd.M.', transitionFormat: 'd.M.'))),
      primaryMeasureAxis:
          charts.NumericAxisSpec(showAxisLine: false, renderSpec: const charts.NoneRenderSpec(), viewport: charts.NumericExtents(minValue, maxValue)),
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      defaultInteractions: true,
      defaultRenderer: charts.LineRendererConfig(strokeWidthPx: 3, radiusPx: 5, roundEndCaps: true),
      selectionModels: [
        charts.SelectionModelConfig(
          updatedListener: (charts.SelectionModel model) {
            if (model.hasDatumSelection) {
              double parsed = model.selectedSeries.first.measureFn(model.selectedDatum.first.index)!.toDouble();
              pointerValueDate = formatDateTimeForGraph(model.selectedSeries.first.domainFn(model.selectedDatum.first.index));
              pointerValue = currencyFormatter(parsed, currency.asString);
            }
          },
          changedListener: (charts.SelectionModel model) {
            if (model.hasDatumSelection) {
              double parsed = model.selectedSeries.first.measureFn(model.selectedDatum.first.index)!.toDouble();
              pointerValueDate = formatDateTimeForGraph(model.selectedSeries.first.domainFn(model.selectedDatum.first.index));

              pointerValue = currencyFormatter(parsed, currency.asString);
            }
          },
        ),
      ],
      behaviors: [
        charts.SelectNearest(
          eventTrigger: charts.SelectionTrigger.tapAndDrag,
        ),
        charts.LinePointHighlighter(
          radiusPaddingPx: 3.0,
          showVerticalFollowLine: charts.LinePointHighlighterFollowLineType.nearest,
          symbolRenderer: CustomCircleSymbolRenderer(currency: currency.asString, context: context),
        ),
      ],
    );
  }

  List<charts.Series<GraphModel, DateTime>> createData(BuildContext context, List<GraphModel> passedData) {
    return [
      charts.Series<GraphModel, DateTime>(
        id: 'Graph',
        seriesColor: charts.ColorUtil.fromDartColor(Theme.of(context).colorScheme.secondary),
        domainFn: (GraphModel sales, _) => sales.time,
        measureFn: (GraphModel sales, _) => sales.price,
        data: passedData,
      )
    ];
  }
}

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  final String currency;
  final BuildContext context;
  CustomCircleSymbolRenderer({Key? key, required this.currency, required this.context});

  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern, Color? fillColor, FillPatternType? fillPattern, Color? strokeColor, double? strokeWidthPx}) {
    super.paint(canvas, bounds, dashPattern: dashPattern, fillColor: fillColor, strokeColor: strokeColor, strokeWidthPx: strokeWidthPx);

    var textStyle = style.TextStyle();
    textStyle.color = charts.ColorUtil.fromDartColor(Theme.of(context).colorScheme.secondaryVariant);
    textStyle.fontSize = 11;
    canvas.drawText(element.TextElement(Chart.pointerValue, style: textStyle), (bounds.left - bounds.width - 25).round(), (bounds.height - 20).round());
    canvas.drawText(element.TextElement(Chart.pointerValueDate, style: textStyle), (bounds.left - bounds.width - 25).round(), (bounds.height - 5).round());
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/analytics/models/model.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnalyticCharts extends StatelessWidget {
  AnalyticCharts({Key? key}) : super(key: key);

  final List<DeveloperSeries> data = [
    DeveloperSeries(
      year: "1",
      money: 14506010,
      barColor: charts.ColorUtil.fromDartColor(Color(0xff7DD390)),
    ),
    DeveloperSeries(
      year: "2",
      money: 7250400,
      barColor: charts.ColorUtil.fromDartColor(Color(0xff7DD390)),
    ),
    DeveloperSeries(
      year: "3",
      money: 5582400,
      barColor: charts.ColorUtil.fromDartColor(Color(0xff7DD390)),
    ),
    DeveloperSeries(
      year: "4",
      money: 5582400,
      barColor: charts.ColorUtil.fromDartColor(Color(0xff7DD390)),
    ),
    DeveloperSeries(
      year: "5",
      money: 7250400,
      barColor: charts.ColorUtil.fromDartColor(Color(0xff7DD390)),
    ),
  ];

  final List<DeveloperSeries> data1 = [
    DeveloperSeries(
      year: "1",
      money: 5389183,
      barColor: charts.ColorUtil.fromDartColor(Color(0xff7EB6EA)),
    ),
    DeveloperSeries(
      year: "2",
      money: 6629001,
      barColor: charts.ColorUtil.fromDartColor(Color(0xff7EB6EA)),
    ),
    DeveloperSeries(
      year: "3",
      money: 7106001,
      barColor: charts.ColorUtil.fromDartColor(Color(0xff7EB6EA)),
    ),
    DeveloperSeries(
      year: "4",
      money: 7106001,
      barColor: charts.ColorUtil.fromDartColor(Color(0xff7EB6EA)),
    ),
    DeveloperSeries(
      year: "5",
      money: 6629001,
      barColor: charts.ColorUtil.fromDartColor(Color(0xff7EB6EA)),
    ),
  ];

  final List<DeveloperSeries> data3 = [
    DeveloperSeries(
      year: "1",
      money: 34124452,
      barColor: charts.ColorUtil.fromDartColor(Color(0xff7EB6EA)),
    ),
    DeveloperSeries(
      year: "2",
      money: 39704579,
      barColor: charts.ColorUtil.fromDartColor(Color(0xff7DD390)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<charts.Series<DeveloperSeries, String>> series = [
      charts.Series(
          id: "money",
          data: data1,
          domainFn: (DeveloperSeries series, _) => series.year,
          measureFn: (DeveloperSeries series, _) => series.money,
          colorFn: (DeveloperSeries series, _) => series.barColor,
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (DeveloperSeries sales, _) =>
          'asfasfasf',
          // insideLabelStyleAccessorFn: (DeveloperSeries sales, _) {
          //   final color = (sales.year == '2014')
          //       ? charts.MaterialPalette.red.shadeDefault
          //       : charts.MaterialPalette.yellow.shadeDefault.darker;
          //   return new charts.TextStyleSpec(color: color);
          // },
          // outsideLabelStyleAccessorFn: (DeveloperSeries sales, _) {
          //   final color = (sales.year == '2014')
          //       ? charts.MaterialPalette.red.shadeDefault
          //       : charts.MaterialPalette.yellow.shadeDefault.darker;
          //   return new charts.TextStyleSpec(color: color);
          // }
      ),
      // charts.Series(
      //   id: "money",
      //   data: data,
      //   domainFn: (DeveloperSeries series, _) => series.year,
      //   measureFn: (DeveloperSeries series, _) => series.money,
      //   colorFn: (DeveloperSeries series, _) => series.barColor,
      //   labelAccessorFn: (DeveloperSeries row, _) => '${row.year}: ${row.money}',
      // ),
    ];
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: 300,
        // width: 1.sw,
        padding: EdgeInsets.all(25),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: _getBarChart()
                ),
                Expanded(
                  child: _getPieChart()
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getBarChart(){
    List<charts.Series<DeveloperSeries, String>> series = [
      charts.Series(
        id: "money",
        data: data1,
        domainFn: (DeveloperSeries series, _) => series.year,
        measureFn: (DeveloperSeries series, _) => series.money,
        colorFn: (DeveloperSeries series, _) => series.barColor,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (DeveloperSeries sales, _) => 'asfasfasf',
        insideLabelStyleAccessorFn: (DeveloperSeries sales, _) {
          final color = (sales.year == '2014')
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.yellow.shadeDefault.darker;
          return new charts.TextStyleSpec(color: color);
        },
        outsideLabelStyleAccessorFn: (DeveloperSeries sales, _) {
          final color = (sales.year == '2014')
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.yellow.shadeDefault.darker;
          return new charts.TextStyleSpec(color: color);
        }
      ),
      charts.Series(
        id: "money",
        data: data,
        domainFn: (DeveloperSeries series, _) => series.year,
        measureFn: (DeveloperSeries series, _) => series.money,
        colorFn: (DeveloperSeries series, _) => series.barColor,
        labelAccessorFn: (DeveloperSeries row, _) => '${row.year}: ${row.money}',
      ),
    ];
    return charts.BarChart(series,
      animate: true,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(),
      defaultRenderer: new charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 1.0),
    );
  }

  _getPieChart(){
    List<charts.Series<DeveloperSeries, String>> series = [
      charts.Series(
        id: "money",
        data: data3,
        domainFn: (DeveloperSeries series, _) => series.year,
        measureFn: (DeveloperSeries series, _) => series.money,
        colorFn: (DeveloperSeries series, _) => series.barColor,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (DeveloperSeries sales, _) =>
        'asfasfasf',
      ),
    ];
    return charts.PieChart(series,
      animate: true,
      // barRendererDecorator: new charts.BarLabelDecorator<String>(),
      // domainAxis: new charts.OrdinalAxisSpec(),
      // defaultRenderer: new charts.BarRendererConfig(
      //     groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 1.0),
    );
  }

}
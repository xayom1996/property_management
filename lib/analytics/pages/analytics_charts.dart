import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:property_management/analytics/models/model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:property_management/analytics/pages/edit_plan_page.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/expenses.dart';

class AnalyticCharts extends StatefulWidget {
  final String title;
  final bool hasEditIcon;
  const AnalyticCharts({Key? key, required this.title, this.hasEditIcon = false}) : super(key: key);

  @override
  State<AnalyticCharts> createState() => _AnalyticChartsState();
}

class _AnalyticChartsState extends State<AnalyticCharts> {
  int currentIndexTab = 0;
  bool isTable = true;

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
    return Container(
      color: kBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: null,
            automaticallyImplyLeading: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoxIcon(
                  iconPath: 'assets/icons/back.svg',
                  iconColor: Colors.black,
                  backgroundColor: Colors.white,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                // Spacer(),
                SizedBox(
                  width: 44,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: body,
                      ),
                      Text(
                        'ЖК Акваленд, 3-к',
                        style: caption,
                      ),
                    ],
                  ),
                ),
                // Spacer(),
                widget.hasEditIcon
                ? BoxIcon(
                    iconPath: 'assets/icons/edit.svg',
                    iconColor: Colors.black,
                    backgroundColor: Colors.white,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditPlanPage()),
                      );
                    },
                  )
                : SizedBox(
                    width: 44,
                  ),
                SizedBox(
                  width: 12,
                ),
                BoxIcon(
                  iconPath: isTable
                      ? 'assets/icons/graph.svg'
                      : 'assets/icons/table.svg',
                  iconColor: Colors.black,
                  backgroundColor: Colors.white,
                  onTap: () {
                    setState(() {
                      isTable = !isTable;
                    });
                  },
                ),
              ],
            ),
            elevation: 0,
            toolbarHeight: 68,
            backgroundColor: kBackgroundColor,
          ),
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: MediaQuery.of(context).orientation == Orientation.portrait && MediaQuery.of(context).size.width <= 800
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/table.svg',
                            color: Color(0xffC4C4C4),
                            height: 72,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: Text(
                              'Для просмотра таблиц и графиков поверните телефон',
                              textAlign: TextAlign.center,
                              style: body.copyWith(
                                color: Color(0xffC7C9CC),
                              ),
                            ),
                          ),
                        ],
                      )
                    : isTable
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Год эксплуатации',
                            style: body.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              child: Row(
                                children: [
                                  for (var i = 0; i < 6; i++)
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: i == 5 ? 0 : 9),
                                        child: Center(
                                          child: Text(
                                            i.toString(),
                                            style: body.copyWith(
                                              fontSize: 14
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          for (var item in planTableItems)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                              child: ExpensesContainer(
                                title: item['title'],
                                expenses: item['objects'],
                                height: 32,
                              ),
                            )
                        ],
                      )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              child: Wrap(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        currentIndexTab = 0;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: currentIndexTab == 0
                                              ? Color(0xff5589F1)
                                              : Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(22))
                                        ),
                                        child: Text(
                                          'Распределение прибыли по годам',
                                          style: caption1.copyWith(
                                            color: currentIndexTab == 0
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        currentIndexTab = 1;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                      decoration: BoxDecoration(
                                          color: currentIndexTab == 1
                                              ? Color(0xff5589F1)
                                              : Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(22))
                                      ),
                                      child: Text(
                                        'Вклад аренды и роста стоимости в прибыль',
                                        style: caption1.copyWith(
                                          color: currentIndexTab == 1
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 2,
                              // width: 1.sw,
                              // padding: EdgeInsets.all(25),
                              child: Container(
                                color: Color(0xffF5F7F9),
                                child: Padding(
                                  padding: const EdgeInsets.all(9.0),
                                  child: Column(
                                    children: <Widget>[
                                      currentIndexTab == 0
                                          ? Expanded(
                                              child: _getBarChart()
                                          )
                                          : Expanded(
                                              child: _getPieChart()
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 16,
                                        width: 16,
                                        color: Color(0xff7DD390),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                        'Прирост рыночной стоимости, руб.',
                                        style: body,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 16,
                                        width: 16,
                                        color: Color(0xff7EB6EA),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                        'Чистый арендный доход, руб.',
                                        style: body,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
              ),
            ],
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
        labelAccessorFn: (DeveloperSeries sales, _) => '${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(sales.money)}',
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
      charts.Series(
        id: "money",
        data: data,
        domainFn: (DeveloperSeries series, _) => series.year,
        measureFn: (DeveloperSeries series, _) => series.money,
        colorFn: (DeveloperSeries series, _) => series.barColor,
        labelAccessorFn: (DeveloperSeries sales, _) => '${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(sales.money)}',
        // labelAccessorFn: (DeveloperSeries row, _) => '${row.year}: ${row.money}',
      ),
    ];
    return charts.BarChart(series,
      animate: true,
      // Set a bar label decorator.
      // Example configuring different styles for inside/outside:
      //       barRendererDecorator: new charts.BarLabelDecorator(
      //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
      //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
      // barRendererDecorator: new charts.BarLabelDecorator<String>(),
      // domainAxis: new charts.OrdinalAxisSpec(),
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
        labelAccessorFn: (DeveloperSeries sales, _) => '${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(sales.money)}',
      ),
    ];
    return charts.PieChart<String>(series,
        animate: true,
        // barRendererDecorator: new charts.BarLabelDecorator<String>(),
        // domainAxis: new charts.OrdinalAxisSpec(),
        // defaultRenderer: new charts.BarRendererConfig(
        //     groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 1.0),
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 60,
            arcRendererDecorators: [new charts.ArcLabelDecorator()])
    );
  }
}
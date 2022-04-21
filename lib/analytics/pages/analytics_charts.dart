import 'dart:io';
import 'dart:math';

import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:property_management/analytics/cubit/analytics_cubit.dart';
import 'package:property_management/analytics/cubit/edit_plan_cubit.dart';
import 'package:property_management/analytics/models/model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:property_management/analytics/pages/edit_plan_page.dart';
import 'package:property_management/analytics/widgets/finance.dart';
import 'package:property_management/analytics/widgets/get_irr.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/custom_alert_dialog.dart';
import 'package:property_management/app/widgets/expenses.dart';
import 'package:property_management/characteristics/models/characteristics.dart';
import 'package:property_management/exploitation/cubit/exploitation_cubit.dart';
import 'package:property_management/objects/bloc/objects_bloc.dart';
import 'package:property_management/objects/models/place.dart';
import 'package:provider/src/provider.dart';
import 'package:collection/collection.dart';

class AnalyticCharts extends StatefulWidget {
  final String title;
  final int? planIndex;
  const AnalyticCharts({Key? key, required this.title, this.planIndex}) : super(key: key);

  @override
  State<AnalyticCharts> createState() => _AnalyticChartsState();
}

class _AnalyticChartsState extends State<AnalyticCharts> {
  int currentIndexTab = 0;
  bool isTable = true;
  bool isLoading = true;
  Map<String, List> table = {};
  List<int> years = [];
  String title = '';

  @override
  void initState() {
    calculationTable();
    super.initState();
  }

  void calculationTable() {
    setState(() {
      isLoading = true;
    });

    Place place = context.read<ObjectsBloc>().state.places[context.read<AnalyticsCubit>().state.selectedPlaceId];
    title = place.objectItems['Название объекта']!.getFullValue();
    Map<String, Characteristics> objectItems = {};
    Map<String, Characteristics> expensesArticleItems = {};

    if (widget.planIndex != null) {
      objectItems = place.plansItems![widget.planIndex!];
      expensesArticleItems = place.plansItems![widget.planIndex!];
    } else {
      objectItems = place.objectItems;
      expensesArticleItems = place.expensesArticleItems ?? {};
    }


    try {
      DateTime startDateCalculation = DateFormat('dd.MM.yyyy').parse(
          expensesArticleItems['Начало даты расчета']!.getFullValue());
      DateTime finishDateCalculation = DateFormat('dd.MM.yyyy').parse(
          expensesArticleItems['Конец даты расчета']!.getFullValue());
      int yearsCount = (finishDateCalculation.difference(startDateCalculation).inDays / 365).ceil();
      years = new List<int>.generate(yearsCount + 1, (i) => i);

      table['Рыночная ставка аренды, руб/кв.м*мес.'] = List.generate(yearsCount + 1, (i) => 0);
      for (var year in years) {
        if (year == 1) {
          table['Рыночная ставка аренды, руб/кв.м*мес.']?[year] = double.parse(expensesArticleItems['Рыночная ставка аренды (в месяц)']!.value!);
        } else if (year > 1) {
          table['Рыночная ставка аренды, руб/кв.м*мес.']?[year] = table['Рыночная ставка аренды, руб/кв.м*мес.']?[year - 1]
              * (100 + double.parse(expensesArticleItems['Индексация рыночной ставки аренды']!.value!)) / 100;
        }
      }

      table['Потенциальный валовый доход, руб./год'] = List.generate(yearsCount + 1, (i) => 0);
      for (var year in years) {
        table['Потенциальный валовый доход, руб./год']?[year] = table['Рыночная ставка аренды, руб/кв.м*мес.']?[year]
            * double.parse(objectItems['Площадь объекта']!.value!) * 12;
      }

      table['Потери от недозагрузки (смена арендатора), %'] = List.generate(yearsCount + 1, (i) => i == 0
          ? i
          : double.parse(expensesArticleItems['Потери от недогрузки (смена арендатора)']!.value!));
      table['Расходы на управление, % от реального дохода'] = List.generate(yearsCount + 1, (i) => i == 0
          ? i
          : double.parse(expensesArticleItems['Расходы на управление (% от реального дохода)']!.value!));
      table['Патент на сдачу в аренду нежилых помещений для ИП, руб./год.'] = List.generate(yearsCount + 1, (i) => i == 0
          ? i
          : double.parse(expensesArticleItems['Патент на сдачу в аренду нежилых помещений для ИП']!.value!));
      table['Банковское обслуживание, руб.'] = List.generate(yearsCount + 1, (i) => i == 0
          ? i
          : double.parse(expensesArticleItems['Банковское обслуживание']!.value!));

      table['Чистый арендный доход, руб'] = List.generate(yearsCount + 1, (i) => 0);
      for (var year in years) {
        if (year != 0) {
          table['Чистый арендный доход, руб']?[year] =
              (table['Потенциальный валовый доход, руб./год']?[year]
                  * (100 - double.parse(
                      expensesArticleItems['Потери от недогрузки (смена арендатора)']!
                      .value!)) / 100
                  * (100 - double.parse(
                      expensesArticleItems['Расходы на управление (% от реального дохода)']!
                      .value!)) / 100)
                  - double.parse(
                      expensesArticleItems['Патент на сдачу в аренду нежилых помещений для ИП']!
                      .value!)
                  - double.parse(
                      expensesArticleItems['Банковское обслуживание']!
                          .value!);
        }
      }

      table['Площадь объекта, кв.м'] = [double.parse(objectItems['Площадь объекта']!.value!)];
      table['Начальная стоимость, руб.'] = [double.parse(objectItems['Начальная стоимость']!.value!)];
      table['Услуги по приобретению, %'] = [double.parse(objectItems['Услуги по приобретению']!.value!)];
      table['Расходы на сделку, руб.'] = [double.parse(objectItems['Расходы на сделку']!.value!)];

      table['Рыночная стоимость помещения, руб.'] = List.generate(yearsCount + 1, (i) => 0);
      for (var year in years) {
        if (year == 0) {
          table['Рыночная стоимость помещения, руб.']?[year] =
              double.parse(objectItems['Начальная стоимость']!.value!)
                * (100 + double.parse(objectItems['Услуги по приобретению']!.value!)) / 100
                + double.parse(objectItems['Расходы на сделку']!.value!);
        }
        else {
          table['Рыночная стоимость помещения, руб.']?[year] =
              table['Рыночная ставка аренды, руб/кв.м*мес.']?[year]
                  * 12
                  * (double.parse(objectItems['Площадь объекта']!.value!)
                  / (double.parse(objectItems['Коэффициент капитализации']!.value!) / 100));
        }
      }

      table['Прибавка в стоимости, руб.'] = List.generate(yearsCount + 1, (i) => 0);
      for (var year in years) {
        if (year != 0) {
          table['Прибавка в стоимости, руб.']?[year] =
              table['Рыночная стоимость помещения, руб.']?[year]
                  - table['Рыночная стоимость помещения, руб.']?[year - 1];
        }
      }

      table['Денежный поток'] = List.generate(yearsCount + 1, (i) => 0);
      for (var year in years) {
        if (year == 0) {
          table['Денежный поток']?[year] = -table['Рыночная стоимость помещения, руб.']?[year];
        } else if (year != years.length - 1) {
          table['Денежный поток']?[year] =
              (table['Потенциальный валовый доход, руб./год']?[year]
                * (100 - double.parse(
                    expensesArticleItems['Потери от недогрузки (смена арендатора)']!
                    .value!)) / 100
                * (100 - double.parse(
                    expensesArticleItems['Расходы на управление (% от реального дохода)']!
                    .value!)) / 100)
                - double.parse(
                    expensesArticleItems['Патент на сдачу в аренду нежилых помещений для ИП']!
                    .value!)
                - double.parse(
                    expensesArticleItems['Банковское обслуживание']!
                        .value!);
        } else {
          table['Денежный поток']?[year] =
              (table['Потенциальный валовый доход, руб./год']?[year]
                  * (100 - double.parse(
                      expensesArticleItems['Потери от недогрузки (смена арендатора)']!
                      .value!)) / 100
                  * (100 - double.parse(
                      expensesArticleItems['Расходы на управление (% от реального дохода)']!
                      .value!)) / 100)
                  - double.parse(
                      expensesArticleItems['Патент на сдачу в аренду нежилых помещений для ИП']!
                      .value!)
                  - double.parse(
                      expensesArticleItems['Банковское обслуживание']!
                          .value!)
                  + table['Рыночная стоимость помещения, руб.']?[year];
        }
      }

      double allRentalIncome = 0;
      for (var year in years) {
        allRentalIncome += table['Чистый арендный доход, руб']?[year];
      }

      double allAddedValue = 0;
      for (var year in years) {
        allAddedValue += table['Прибавка в стоимости, руб.']?[year];
      }

      table['Чистый арендный доход(общий), руб'] = [allRentalIncome, (allRentalIncome / (allAddedValue + allRentalIncome)) * 100];

      table['Прибавка в стоимости(общая), руб.'] = [allAddedValue, (allAddedValue / (allAddedValue + allRentalIncome)) * 100];

      table['Чистая прибыль за период, руб.'] = [allRentalIncome + allAddedValue, 100];
      table['Внутренняя норма доходности в год'] = [internal_rate_of_return(List.generate(table['Денежный поток']!.length, (index) => table['Денежный поток']?[index]), 0, 0)];
      setState(() {
        isLoading = false;
      });
    } catch (_) {
      print(_);
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => CustomAlertDialog(
              title: context.read<AppBloc>().state.user.isAdminOrManager()
                  ? 'Заполните необходимые данные по объекту'
                  : 'Данные не заполнены',
              firstButtonTitle: 'Ок',
              secondButtonTitle: null,
            )
        ).then((val){
          Navigator.pop(context);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kBackgroundColor,
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
                        title,
                        style: caption,
                      ),
                    ],
                  ),
                ),
                // Spacer(),
                widget.planIndex != null && context.read<AppBloc>().state.user.isAdminOrManager()
                ? BoxIcon(
                    iconPath: 'assets/icons/edit.svg',
                    iconColor: Colors.black,
                    backgroundColor: Colors.white,
                    onTap: () {
                      Place place = context.read<ObjectsBloc>().state.places[context.read<AnalyticsCubit>().state.selectedPlaceId];
                      context.read<EditPlanCubit>().getItems(place.plansItems![widget.planIndex!], place.id);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditPlanPage(
                          planIndex: widget.planIndex!,
                          calculateTable: calculationTable,
                        )),
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
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : MediaQuery.of(context).orientation == Orientation.portrait && MediaQuery.of(context).size.width <= 800
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
                                    for (var i = 0; i < years.length; i++)
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(right: i == years.length - 1 ? 0 : 9),
                                          child: Center(
                                            child: Text(
                                              years[i].toString(),
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
                            for (var title in table.keys)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                                child: ExpensesContainer(
                                  title: title,
                                  expenses: List.generate(table[title]!.length, (index) {
                                    if (table[title]![index] == 0 && index == 0 && table[title]!.length != 1) {
                                      return '';
                                    }
                                    if (title == 'Внутренняя норма доходности в год'
                                        || (title == 'Чистый арендный доход(общий), руб' && index == 1)
                                        || (title == 'Прибавка в стоимости(общая), руб.' && index == 1)
                                        || (title == 'Чистая прибыль за период, руб.' && index == 1) || (title.contains('%'))) {
                                      return removeTrailingZeros(table[title]![index].toString()) + '%';
                                    }
                                    if (title.contains('руб') || title == 'Денежный поток') {
                                      return formatNumber(removeTrailingZeros(table[title]![index].round().toString()), '');
                                    }
                                    return formatNumber(removeTrailingZeros(table[title]![index].toString()), '');
                                  }),
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
                                            borderRadius: BorderRadius.all(Radius.circular(22)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 20,
                                                offset: Offset(0, 4), // changes position of shadow
                                              ),
                                            ],
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
                                            borderRadius: BorderRadius.all(Radius.circular(22)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 20,
                                                offset: Offset(0, 4), // changes position of shadow
                                              ),
                                            ],
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
    final List<DeveloperSeries> data1 = List.generate(years.length - 1, (i) =>
        DeveloperSeries(
          year: "${i + 1}",
          money: table['Чистый арендный доход, руб']?[i + 1].round(),
          barColor: charts.ColorUtil.fromDartColor(Color(0xff7EB6EA)),
        )
    );

    final List<DeveloperSeries> data = List.generate(years.length - 1, (i) =>
        DeveloperSeries(
          year: "${i + 1}",
          money: table['Прибавка в стоимости, руб.']?[i + 1].round(),
          barColor: charts.ColorUtil.fromDartColor(Color(0xff7DD390)),
        ),
    );

    List<charts.Series<DeveloperSeries, String>> series = [
      charts.Series(
        id: "money",
        data: data1,
        domainFn: (DeveloperSeries series, _) => series.year,
        measureFn: (DeveloperSeries series, _) => series.money,
        colorFn: (DeveloperSeries series, _) => series.barColor,
        labelAccessorFn: (DeveloperSeries sales, _) => '${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(sales.money)}',
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
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: const charts.OrdinalAxisSpec(),
      // vertical: false,
      defaultRenderer: charts.BarRendererConfig(
        groupingType: charts.BarGroupingType.groupedStacked,
        strokeWidthPx: 2.0,
      ),
    );
  }

  _getPieChart(){
    final List<DeveloperSeries> data3 = [
      DeveloperSeries(
        year: "1",
        money: table['Чистый арендный доход(общий), руб']?[0].round(),
        procent: removeTrailingZeros(table['Чистый арендный доход(общий), руб']![1].toString()) + '%',
        barColor: charts.ColorUtil.fromDartColor(Color(0xff7EB6EA)),
      ),
      DeveloperSeries(
        year: "2",
        procent: removeTrailingZeros(table['Прибавка в стоимости(общая), руб.']![1].toString()) + '%',
        money: table['Прибавка в стоимости(общая), руб.']?[0].round(),
        barColor: charts.ColorUtil.fromDartColor(Color(0xff7DD390)),
      ),
    ];

    List<charts.Series<DeveloperSeries, String>> series = [
      charts.Series(
        id: "money",
        data: data3,
        domainFn: (DeveloperSeries series, _) => series.year,
        measureFn: (DeveloperSeries series, _) => series.money,
        colorFn: (DeveloperSeries series, _) => series.barColor,
        insideLabelStyleAccessorFn: (DeveloperSeries sales, _) {
          const color = charts.MaterialPalette.white;

          return const charts.TextStyleSpec(
            // fontFamily: 'ptSans',
            // fontSize: 17,
            color: color
          );
        },
        // outsideLabelStyleAccessorFn: (DeveloperSeries sales, _) =>
        //   const charts.TextStyleSpec(
        //     fontFamily: 'ptSans',
        //     fontSize: 17,
        //   ),
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (DeveloperSeries sales, _) => '${NumberFormat.currency(locale: 'ru', symbol: '', decimalDigits: 0).format(sales.money)}\n${sales.procent}',
      ),
    ];
    return charts.PieChart<String>(series,
        animate: true,
        defaultRenderer: charts.ArcRendererConfig(
            arcWidth: 300,
            arcRendererDecorators: [charts.ArcLabelDecorator()],
        )
    );
  }
}
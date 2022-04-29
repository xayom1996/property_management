import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:property_management/analytics/models/model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/custom_alert_dialog.dart';
import 'package:property_management/app/widgets/expenses.dart';
import 'package:property_management/objects/bloc/objects_bloc.dart';
import 'package:property_management/objects/models/place.dart';

class TotalCharts extends StatefulWidget {
  // final String title;
  const TotalCharts({Key? key}) : super(key: key);

  @override
  State<TotalCharts> createState() => _TotalChartsState();
}

class _TotalChartsState extends State<TotalCharts> {
  int currentIndexTab = 0;
  bool isTotalTable = true;
  bool isLoading = false;
  Map<String, List> table = {};
  Map<String, num> totalTable = {};
  List<String> places = [];
  List<bool> hasTenantName = [];
  String currentDate = '';
  late StreamSubscription _objectsSubscription;

  @override
  void initState() {
    currentDate = DateFormat('MM.yyyy').format(DateTime.now());
    calculationTable();
    _objectsSubscription = context.read<ObjectsBloc>().stream.listen(
            (state){
          if (state.status == ObjectsStatus.fetched && mounted){
            calculationTable();
          }
        });
    super.initState();
  }

  void calculationTable() {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }


    places = [];
    hasTenantName = [];
    table = {};
    String currentDate = DateFormat('MM.yyyy').format(DateTime.now());

    for (var place in context.read<ObjectsBloc>().state.places) {
      String objectName = place.objectItems[0].value ?? '';
      String objectArea = place.objectItems[2].value ?? '';
      String objectDate = place.objectItems[7].value ?? '';
      String objectPrice = place.objectItems[6].value ?? '';
      String objectCapitalization = place.objectItems[15].value ?? '';
      String objectRent = isNotEmpty(place.objectItems[14].value)
          ? place.objectItems[14].value!
          : '0';
      String tenantName = place.tenantItems != null
          ? place.tenantItems![0].value ?? ''
          : '';

      if (objectName.isEmpty || objectDate.isEmpty || objectArea.isEmpty
          || objectPrice.isEmpty || objectCapitalization.isEmpty || objectCapitalization == '0') {
        continue;
      }

      places.add(objectName);
      hasTenantName.add(tenantName.isNotEmpty);
      int yearsCount = (DateTime.now().difference(DateFormat('dd.MM.yyyy').parse(objectDate)).inDays / 365).ceil();
      objectDate = DateFormat('MM.yyyy').format(DateFormat('dd.MM.yyyy').parse(objectDate));

      if (table['Площадь, кв.м.'] == null) {
        table['Площадь, кв.м.'] = [];
      }
      table['Площадь, кв.м.']!.add(double.parse(objectArea));

      if (table['Период покупки'] == null) {
        table['Период покупки'] = [];
      }
      table['Период покупки']!.add(objectDate);

      if (table['Цена покупки помещения, руб.'] == null) {
        table['Цена покупки помещения, руб.'] = [];
      }
      table['Цена покупки помещения, руб.']!.add(double.parse(objectPrice));

      if (table['Цена покупки помещения за 1 м2, руб.'] == null) {
        table['Цена покупки помещения за 1 м2, руб.'] = [];
      }
      table['Цена покупки помещения за 1 м2, руб.']!.add(
          double.parse(objectPrice) / double.parse(objectArea)
      );

      if (table['Оценочная стоимость помещения на $currentDate, руб.'] == null) {
        table['Оценочная стоимость помещения на $currentDate, руб.'] = [];
      }

      if (table['Оценочная стоимость помещения за 1 м2 на $currentDate, руб.'] == null) {
        table['Оценочная стоимость помещения за 1 м2 на $currentDate, руб.'] = [];
      }

      if (table['Удорожание (прибавка в стоимости) помещения к $currentDate, руб.'] == null) {
        table['Удорожание (прибавка в стоимости) помещения к $currentDate, руб.'] = [];
      }

      if (table['Ежегодное удорожание помещения, %'] == null) {
        table['Ежегодное удорожание помещения, %'] = [];
      }

      if (table['Фактическая/ Расчетная ставка аренды, руб./м2 в мес. (на $currentDate или к началу доходной эксплуатации)'] == null) {
        table['Фактическая/ Расчетная ставка аренды, руб./м2 в мес. (на $currentDate или к началу доходной эксплуатации)'] = [];
      }
      table['Фактическая/ Расчетная ставка аренды, руб./м2 в мес. (на $currentDate или к началу доходной эксплуатации)']!.add(
          double.parse(objectRent) / double.parse(objectArea)
      );

      if (table['Фактическая/ Расчётная аренда за Помещение, руб. в год (на $currentDate или к началу доходной эксплуатации)'] == null) {
        table['Фактическая/ Расчётная аренда за Помещение, руб. в год (на $currentDate или к началу доходной эксплуатации)'] = [];
      }
      table['Фактическая/ Расчётная аренда за Помещение, руб. в год (на $currentDate или к началу доходной эксплуатации)']!.add(
          table['Фактическая/ Расчетная ставка аренды, руб./м2 в мес. (на $currentDate или к началу доходной эксплуатации)']!.last * 12 * double.parse(objectArea)
      );

      table['Оценочная стоимость помещения на $currentDate, руб.']!.add(
          table['Фактическая/ Расчётная аренда за Помещение, руб. в год (на $currentDate или к началу доходной эксплуатации)']!.last / (double.parse(objectCapitalization) / 100)
      );

      table['Оценочная стоимость помещения за 1 м2 на $currentDate, руб.']!.add(
          table['Оценочная стоимость помещения на $currentDate, руб.']!.last / double.parse(objectArea)
      );

      table['Удорожание (прибавка в стоимости) помещения к $currentDate, руб.']!.add(
          table['Оценочная стоимость помещения на $currentDate, руб.']!.last
              - table['Цена покупки помещения, руб.']!.last
      );

      table['Ежегодное удорожание помещения, %']!.add(
          objectRent == '0' || yearsCount < 2
              ? ''
              : (pow(yearsCount, (
              log(table['Оценочная стоимость помещения на $currentDate, руб.']!.last
                  / table['Цена покупки помещения, руб.']!.last) / log(yearsCount)
          ) / yearsCount) - 1) * 100
      );
    }

    if (places.isNotEmpty) {
      double sum = table['Площадь, кв.м.']!.fold(0, (previous, current) => previous + current);
      table['Площадь, кв.м.']!.add(sum);

      table['Период покупки']!.add('');

      sum = table['Цена покупки помещения, руб.']!.fold(0, (previous, current) => previous + current);
      table['Цена покупки помещения, руб.']!.add(sum);

      table['Цена покупки помещения за 1 м2, руб.']!.add('');

      sum = table['Оценочная стоимость помещения на $currentDate, руб.']!.fold(0, (previous, current) => previous + current);
      table['Оценочная стоимость помещения на $currentDate, руб.']!.add(sum);

      table['Оценочная стоимость помещения за 1 м2 на $currentDate, руб.']!.add('');

      sum = table['Удорожание (прибавка в стоимости) помещения к $currentDate, руб.']!.fold(0, (previous, current) => previous + current);
      table['Удорожание (прибавка в стоимости) помещения к $currentDate, руб.']!.add(sum);

      sum = table['Фактическая/ Расчётная аренда за Помещение, руб. в год (на $currentDate или к началу доходной эксплуатации)']!.fold(0, (previous, current) => previous + current);
      table['Фактическая/ Расчётная аренда за Помещение, руб. в год (на $currentDate или к началу доходной эксплуатации)']!.add(sum);

      sum = table['Фактическая/ Расчетная ставка аренды, руб./м2 в мес. (на $currentDate или к началу доходной эксплуатации)']!.fold(0, (previous, current) => previous + current);
      table['Фактическая/ Расчетная ставка аренды, руб./м2 в мес. (на $currentDate или к началу доходной эксплуатации)']!.add(
          table['Фактическая/ Расчётная аренда за Помещение, руб. в год (на $currentDate или к началу доходной эксплуатации)']!.last
              / 12 / table['Площадь, кв.м.']!.last
      );

      double sum1 = 0;
      double sum2 = 0;
      for (var i = 0; i < table['Ежегодное удорожание помещения, %']!.length; i++) {
        if (table['Ежегодное удорожание помещения, %']![i] != '') {
          sum1 += table['Площадь, кв.м.']![i] * (table['Ежегодное удорожание помещения, %']![i] / 100);
          sum2 += table['Площадь, кв.м.']![i];
        }
      }
      table['Ежегодное удорожание помещения, %']!.add(
          sum2 == 0
              ? ''
              : (sum1 / sum2) * 100
      );

      totalTable['Количество помещений'] = places.length;
      totalTable['Средняя покупная стоимость помещения'] = table['Цена покупки помещения, руб.']!.last / places.length;
      totalTable['Средняя покупная стоимость за 1м2'] = table['Цена покупки помещения, руб.']!.last / table['Площадь, кв.м.']!.last;
      totalTable['Средняя стоимость помещений на $currentDate'] = table['Оценочная стоимость помещения на $currentDate, руб.']!.last / places.length;
      totalTable['Средняя стоимость помещений за 1м2 на $currentDate'] = table['Оценочная стоимость помещения на $currentDate, руб.']!.last / table['Площадь, кв.м.']!.last;
      totalTable['Средняя прибавка в стоимости (Удорожание) 1м2 всех помещений за всё время (на $currentDate)'] = 0;
      totalTable['Общая прибавка в стоимости (Удорожание) всех помещений на $currentDate.'] = table['Оценочная стоимость помещения на $currentDate, руб.']!.last - table['Цена покупки помещения, руб.']!.last;
      totalTable['Средняя прибавка в стоимости (Удорожание) 1м2 всех помещений за всё время (на $currentDate)'] = totalTable['Общая прибавка в стоимости (Удорожание) всех помещений на $currentDate.']! / table['Площадь, кв.м.']!.last;
      totalTable['Средняя стоимость аренды помещений за 1 м2 на $currentDate'] = table['Фактическая/ Расчетная ставка аренды, руб./м2 в мес. (на $currentDate или к началу доходной эксплуатации)']!.last;
      totalTable['Средний прирост стоимости в год'] = table['Ежегодное удорожание помещения, %']!.last == ''
          ? 0
          : table['Ежегодное удорожание помещения, %']!.last;

      places.add('Всего');
      hasTenantName.add(false);
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }

  }

  // List headerTitles = ['ЖК Акваленд, 3-к', 'ЖК ЭКО, 3-к', 'ЖК ЭКО, 3-к', 'ЖК Акваленд, 3-к', 'ЖК ЭКО, 3-к', 'ЖК ЭКО, 3-к', 'ЖК Акваленд, 3-к', 'ЖК ЭКО, 3-к', 'Всего'];
  List headerTitles = [];

  String getRangeDate() {
    DateTime date1 = DateTime.now();
    DateTime date2 = DateTime(date1.year - 2, date1.month, date1.day);

    return 'с ${DateFormat('MM.yyyy').format(date2)} по ${DateFormat('MM.yyyy').format(date1)}';
  }

  // bool isHandedObject(Place place) {
  //   int count = 0;
  //   DateTime now = DateTime.now();
  //   String date1 = DateFormat('MM.yyyy').format(DateTime(now.year, now.month - 1, now.day));
  //   String date2 = DateFormat('MM.yyyy').format(DateTime(now.year, now.month - 2, now.day));
  //   String date3 = DateFormat('MM.yyyy').format(DateTime(now.year, now.month - 3, now.day));
  //   for (var expense in place.expensesItems ?? []){
  //     String date = expense[0].getFullValue();
  //
  //     if (date == date1 || date == date2 || date == date3){
  //       if (isNotEmpty(expense['Текущая арендная плата']!.getFullValue())) {
  //         if (int.parse(expense['Текущая арендная плата']!.value) > 0) {
  //           count++;
  //         }
  //       }
  //     }
  //   }
  //   return (widget.title == 'Объекты в эксплуатации' && count == 3)
  //       || (widget.title == 'Объекты спекулятивного типа' && count != 3);
  // }

  @override
  Widget build(BuildContext context) {
    // List<Place> places = context.read<ObjectsBloc>().state.places;
    // for (var place in places) {
    //   if (isHandedObject(place)) {
    //     headerTitles.add(place.objectItems[0].getFullValue());
    //   }
    // }
    // if (headerTitles.isNotEmpty) {
    //   headerTitles.add('Всего');
    // }
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
                Container(
                  width: 44,
                  height: 44,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      MediaQuery.of(context).orientation == Orientation.portrait
                          && MediaQuery.of(context).size.width <= 800 || (places.isEmpty && !isLoading) || isTotalTable
                          ? 'Итоги'
                          : 'Текущая оценка стоимостей по состоянию на $currentDate г.',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: body,
                    ),
                  ),
                ),
                // Text(
                //   'Текущая оценка стоимостей по состоянию на 04.2022 г.',
                //   textAlign: TextAlign.center,
                //   style: body,
                // ),
                // Spacer(),
                BoxIcon(
                  iconPath: isTotalTable
                      ? 'assets/icons/table.svg'
                      : 'assets/icons/table.svg',
                  iconColor: Colors.black,
                  backgroundColor: Colors.white,
                  onTap: () {
                    setState(() {
                      isTotalTable = !isTotalTable;
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
                child: MediaQuery.of(context).orientation == Orientation.portrait
                    && MediaQuery.of(context).size.width <= 800 && !isTotalTable || (places.isEmpty && !isLoading)
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
                              places.isEmpty && !isLoading
                                ? context.read<AppBloc>().state.user.isAdminOrManager()
                                  ? 'Для расчета таблицы заполните необходимые данные по объекту'
                                  : 'Данные не заполнены'
                                : 'Для просмотра таблиц и графиков поверните телефон',
                              textAlign: TextAlign.center,
                              style: body.copyWith(
                                color: Color(0xffC7C9CC),
                              ),
                            ),
                          ),
                        ],
                      )
                    : !isTotalTable
                      ? Stack(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12, left: 24, right: 24, top: 24),
                                  child: Container(
                                    height: 32,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: places.length,
                                        itemBuilder: (BuildContext context, int index) => Container(
                                          width: 128,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: index == 5 ? 0 : 9),
                                            child: Center(
                                              child: Text(
                                                places[index],
                                                style: body.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: index == places.length - 1
                                                      ? FontWeight.w700
                                                      : FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ),
                                  ),
                                ),
                                if (places.isNotEmpty)
                                  for (var title in table.keys)
                                    Padding(
                                      padding: EdgeInsets.only(left: 24, right: 24, bottom: 8),
                                      child: ExpensesContainer(
                                        title: title,
                                        hasTenantName: hasTenantName,
                                        expenses: List.generate(table[title]!.length, (index) {
                                            if (title == 'Период покупки') {
                                              return table[title]![index];
                                            }

                                            if (table[title]![index] == '') {
                                              return '';
                                            }

                                            if (title.contains('%')) {
                                              return removeTrailingZeros(table[title]![index].toString()) + '%';
                                            }

                                            if (title.contains('руб') || title == 'Денежный поток') {
                                              return formatNumber(removeTrailingZeros(table[title]![index].round().toString()), '');
                                            }
                                            return formatNumber(removeTrailingZeros(table[title]![index].toString()), '');
                                          }
                                        ),
                                        width: 128,
                                        height: 32,
                                        isLastElementBold: true,
                                      ),
                                    )
                              ],
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                'Объект',
                                textAlign: TextAlign.center,
                                style: body.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                      : Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    'Общие показатели инвестиций в текущих оценках \n стоимостей по состоянию на $currentDate г.',
                                    textAlign: TextAlign.center,
                                    style: body.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              for (var key in totalTable.keys)
                                Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            key,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: body,
                                          ),
                                        ),
                                        Text(
                                          key == 'Средний прирост стоимости в год' && totalTable[key] == 0
                                          ? ''
                                          : formatNumber(
                                                removeTrailingZeros(totalTable[key].toString()),
                                                key == 'Количество помещений'
                                                    ? 'шт'
                                                    : key == 'Средний прирост стоимости в год'
                                                      ? '%'
                                                      : '₽',
                                            ),
                                          style: body,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    if (totalTable.keys.last != key)
                                      Divider(),
                                    SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                      )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
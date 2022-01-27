import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/characteristics/widgets/custom_tab_view.dart';
import 'package:property_management/objects/pages/edit_object_page.dart';
import 'package:property_management/objects/pages/edit_tenant_page.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/custom_alert_dialog.dart';
import 'package:property_management/app/widgets/custom_carousel_slider.dart';
import 'package:property_management/app/widgets/custom_tab_container.dart';
import 'package:provider/src/provider.dart';

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class CharacteristicsPage extends StatefulWidget {
  const CharacteristicsPage({Key? key}) : super(key: key);

  @override
  State<CharacteristicsPage> createState() => _CharacteristicsPageState();
}

class _CharacteristicsPageState extends State<CharacteristicsPage> {
  bool isLoading = true;
  int currentIndexTab = 0;

  List<Map> firstTabObjectItems = [
    {'title': 'Собственник', 'value': 'УК Смарт'},
    {'title': 'Выделенная мощность (электричество)', 'value': '2'},
    {'title': 'Выделенная мощность (тепло)', 'value': '2'},
    {'title': 'Начальная стоимость', 'value': '1 000 000 ₽'},
    {'title': 'Дата приобретения', 'value': '07.05.2021'},
    {'title': 'Рыночная стоимость помещения', 'value': '900 000 ₽'},
    {'title': 'Кадастровый номер', 'value': ''},
    {'title': 'Кадастровая стоимость', 'value': '900 000 ₽'},
    {'title': 'Договор водоснабжения', 'value': 'Договор от 12.04.14'},
    {'title': 'Система налогообложения', 'value': 'Патент'},
    {'title': 'Фактическая Налоговая нагрузка', 'value': '10 000 ₽'},
    {'title': 'Арендная плата', 'value': '30 000 ₽'},
    {'title': 'Коэффициент капитализации', 'value': '1,2'},
  ];

  List<Map> secondTabObjectItems = [];

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      setState(() {
        isLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              centerTitle: true,
              elevation: 0,
              forceElevated: innerBoxIsScrolled,
              title: context.read<AppBloc>().state.user.role != 'user'
                  ? Row(
                      children: [
                        Spacer(),
                        BoxIcon(
                          iconPath: 'assets/icons/edit.svg',
                          iconColor: Colors.black,
                          backgroundColor: Colors.white,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => currentIndexTab == 0
                                  ? EditObjectPage()
                                  : EditTenantPage(),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        BoxIcon(
                          iconPath: 'assets/icons/trash.svg',
                          iconColor: Colors.black,
                          backgroundColor: Colors.white,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => CustomAlertDialog(
                                  title: 'Вы действительно хотите удалить карточку объекта?',
                                )
                            );
                          },
                        ),
                      ],
                    )
                  : null,
              expandedHeight: 70,
              toolbarHeight: 70,
              collapsedHeight: 70,
              pinned: true,
              backgroundColor: kBackgroundColor,
              flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.symmetric(vertical: 24),
                  title: Text('Характеристики',
                      style: body,
                  ),
                );
              })
            ),
            SliverPersistentHeader(
              pinned: false,
              delegate: _SliverAppBarDelegate(
                minHeight: 83,
                maxHeight: 83,
                child: CustomCarouselSlider(),
              ),
            ),
            SliverPersistentHeader(
              pinned: false,
              delegate: _SliverAppBarDelegate(
                minHeight: 24,
                maxHeight: 24,
                child: Container(
                  color: kBackgroundColor,
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 53,
                maxHeight: 53,
                child: CustomTabContainer(
                  firstTab: 'Объект',
                  secondTab: 'Арендатор',
                  currentIndex: currentIndexTab,
                  onChange: (int index) {
                    setState(() {
                      currentIndexTab = index;
                    });
                  },
                ),
              ),
            ),
          ];
        },
        body: currentIndexTab == 0
            ? CustomTabView(
                objectItems: objectItemsFilled
              )
            : CustomTabView(
                objectItems: tenantItemsFilled,
                checkbox: true,
                // textButton: secondTabObjectItems.isEmpty
                //     ? GestureDetector(
                //       onTap: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(builder: (context) => CreateTenantPage()),
                //         );
                //       },
                //       child: Row(
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             SvgPicture.asset(
                //               'assets/icons/plus.svg',
                //               color: Color(0xff4B81EF),
                //               height: 16,
                //             ),
                //             SizedBox(width: 10),
                //             Text(
                //               'Добавить характеристики арендатора',
                //               style: title2.copyWith(
                //                   color: Color(0xff4B81EF),
                //                   fontSize: 14,
                //                   fontWeight: FontWeight.w400
                //               ),
                //             ),
                //           ],
                //         ),
                //     )
                //     : null,
              ),
      ),
    );
  }
}
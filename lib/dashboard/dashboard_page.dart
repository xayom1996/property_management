import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/analytics/pages/analytics_page.dart';
import 'package:property_management/authorization/pages/authorization_page.dart';
import 'package:property_management/characteristics/pages/characteristics_page.dart';
import 'package:property_management/exploitation/pages/exploitation_page.dart';
import 'package:property_management/objects/pages/list_objects_page.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/total/pages/total_page.dart';
import 'package:property_management/utils/utils.dart';
import 'package:property_management/widgets/box_icon.dart';


class DashboardPage extends StatefulWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController textController = new TextEditingController();

  int currentIndex = 0;

  late List<Widget> pages;
  // [
  //   ListObjectsPage(
  //     goToCharacteristicsPage: () {
  //       setState(() {
  //         currentIndex = 0;
  //       });
  //     },
  //   ),
  //   CharacteristicsPage(),
  //   ExploitationPage(),
  //   AnalyticsPage(),
  //   TotalPage(),
  // ];

  @override
  void initState() {
    pages = [
      ListObjectsPage(
        goToCharacteristicsPage: () {
          onChangeIndex(1);
        },
      ),
      CharacteristicsPage(),
      ExploitationPage(),
      AnalyticsPage(),
      TotalPage(),
    ];
    super.initState();
  }

  void onChangeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: IndexedStack(
              key: const PageStorageKey('Indexed'),
              index: currentIndex,
              children: pages,
            ),
      ),
      bottomNavigationBar: MyNavBar(
        currentIndex: currentIndex,
        onTap: onChangeIndex,
        items: const [
          {
            'iconPath': 'assets/icons/home.svg',
            'title': 'Объекты',
          },
          {
            'iconPath': 'assets/icons/characteristic.svg',
            'title': 'Характеристики',
          },
          {
            'iconPath': 'assets/icons/exploitation.svg',
            'title': 'Эксплуатация',
          },
          {
            'iconPath': 'assets/icons/analytics.svg',
            'title': 'Аналитика',
          },
          {
            'iconPath': 'assets/icons/total.svg',
            'title': 'Итоги',
          },
        ],
      ),
    );
  }
}

class MyNavBar extends StatelessWidget{
  final List<Map> items;
  final int currentIndex;
  final Function(int) onTap;

  MyNavBar({Key? key, required this.items, required this.currentIndex,
    required this.onTap}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffFCFCFC).withOpacity(0.83),
                Color(0xffFCFCFC),
              ]
          )
        ),
        // padding: EdgeInsets.symmetric(horizontal: horizontalPadding(0.25.sw)),
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 16 : 0),
        child: Align(
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) =>
                InkWell(
                  onTap: (){
                    onTap(index);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: index != items.length - 1
                        ? ScreenUtil().orientation == Orientation.portrait && 1.sw <= 750
                          ? 16
                          : 32
                        : 0,
                    ),
                    child: Flex(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      direction: ScreenUtil().orientation == Orientation.portrait && 1.sw <= 750
                          ? Axis.vertical
                          : Axis.horizontal,
                      children: [
                        BoxIcon(
                          iconPath: items[index]['iconPath'],
                          iconColor: index == currentIndex ? Colors.white : Colors.black,
                          backgroundColor: Colors.white,
                          gradient: index == currentIndex
                              ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xff6395F9),
                                      Color(0xff0940CD),
                                    ]
                                )
                              : null,
                        ),
                        ScreenUtil().orientation == Orientation.portrait && 1.sw <= 750
                            ? SizedBox(
                                height: 2,
                              )
                            : SizedBox(
                                width: 8,
                              ),
                        Text(
                          items[index]['title'],
                          style: caption2,
                        )
                      ],
                    ),
                  ),
                ),
            ),
          ),
        )
    );
  }

}

import 'dart:async';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/analytics/models/model.dart';
import 'package:property_management/analytics/pages/analytics_charts.dart';
import 'package:property_management/analytics/pages/create_plan_page.dart';
import 'package:property_management/characteristics/widgets/custom_tab_view.dart';
import 'package:property_management/objects/widgets/object_card.dart';
import 'package:property_management/objects/widgets/object_skeleton.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/utils/utils.dart';
import 'package:property_management/widgets/box_button.dart';
import 'package:property_management/widgets/box_icon.dart';
import 'package:property_management/widgets/container_for_transition.dart';
import 'package:property_management/widgets/custom_carousel_slider.dart';
import 'package:property_management/widgets/custom_tab_container.dart';
import 'package:property_management/widgets/input_field.dart';
import 'package:property_management/widgets/object_carousel_card.dart';

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

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  bool isLoading = true;
  int currentIndexTab = 0;

  List<Map> firstTabObjectItems = [];

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
                expandedHeight: 70,
                toolbarHeight: 70,
                collapsedHeight: 70,
                pinned: true,
                backgroundColor: kBackgroundColor,
                flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                  return FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding: EdgeInsets.symmetric(vertical: 24),
                    title: Text('Аналитика',
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
                child: Container(),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 53,
                maxHeight: 53,
                child: CustomTabContainer(
                  firstTab: 'План',
                  secondTab: 'Факт',
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
          objectItems: firstTabObjectItems,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44), vertical: 16),
              child: Column(
                children: [
                  Slidable(
                    key: ValueKey(0),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        Spacer(),
                        BoxIcon(
                          iconPath: 'assets/icons/trash.svg',
                          iconColor: Colors.black,
                          backgroundColor: Colors.white,
                          onTap: () {
                            // showDialog(
                            //     context: context,
                            //     builder: (context) => CustomAlertDialog()
                            // );
                          },
                        ),
                      ],
                    ),
                    child: ContainerForTransition(
                      title: 'План первый',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AnalyticCharts(
                            title: 'План первый',
                          )),
                        );
                      },
                    ),
                  ),
                  Slidable(
                    key: ValueKey(1),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        Spacer(),
                        BoxIcon(
                          iconPath: 'assets/icons/trash.svg',
                          iconColor: Colors.black,
                          backgroundColor: Colors.white,
                          onTap: () {
                            // showDialog(
                            //     context: context,
                            //     builder: (context) => CustomAlertDialog()
                            // );
                          },
                        ),
                      ],
                    ),
                    child: ContainerForTransition(
                      title: 'План второй',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AnalyticCharts(
                            title: 'План второй',
                          )),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreatePlanPage()),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/plus.svg',
                          color: Color(0xff4B81EF),
                          height: 16,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Добавить план',
                          style: title2.copyWith(
                              color: Color(0xff4B81EF),
                              fontSize: 14,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          textButton: secondTabObjectItems.isEmpty
              ? GestureDetector(
            onTap: () {

            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/plus.svg',
                  color: Color(0xff4B81EF),
                  height: 16,
                ),
                SizedBox(width: 10),
                Text(
                  'Добавить план',
                  style: title2.copyWith(
                      color: Color(0xff4B81EF),
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
          )
              : null,
        )
            : CustomTabView(
          objectItems: secondTabObjectItems,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44), vertical: 16),
              child: Column(
                children: [
                  ContainerForTransition(
                    title: 'Таблица “Факт”',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AnalyticCharts(
                          title: 'Таблица “Факт”',
                        )),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          textButton: secondTabObjectItems.isEmpty
              ? GestureDetector(
            onTap: () {

            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/plus.svg',
                  color: Color(0xff4B81EF),
                  height: 16,
                ),
                SizedBox(width: 10),
                Text(
                  'Добавить факт',
                  style: title2.copyWith(
                      color: Color(0xff4B81EF),
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
          )
              : null,
        ),
      ),
    );
  }
}
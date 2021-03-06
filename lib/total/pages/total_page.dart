import 'dart:async';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/analytics/pages/analytics_charts.dart';
import 'package:property_management/characteristics/widgets/custom_tab_view.dart';
import 'package:property_management/objects/widgets/object_card.dart';
import 'package:property_management/objects/widgets/object_skeleton.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/total/pages/total_charts.dart';
import 'package:property_management/utils/utils.dart';
import 'package:property_management/widgets/box_button.dart';
import 'package:property_management/widgets/box_icon.dart';
import 'package:property_management/widgets/container_for_transition.dart';
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

class TotalPage extends StatefulWidget {
  const TotalPage({Key? key}) : super(key: key);

  @override
  State<TotalPage> createState() => _TotalPageState();
}

class _TotalPageState extends State<TotalPage> {
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
                    title: Text('??????????',
                      style: body,
                    ),
                  );
                })
            ),
            // SliverPersistentHeader(
            //   pinned: false,
            //   delegate: _SliverAppBarDelegate(
            //     minHeight: 75,
            //     maxHeight: 75,
            //     child: CarouselSlider(
            //       options: CarouselOptions(
            //         // aspectRatio: 2.0,
            //         // enlargeCenterPage: true,
            //           height: 75,
            //           enableInfiniteScroll: true,
            //           onPageChanged: (int index, CarouselPageChangedReason reason) {
            //             print(index);
            //           }
            //       ),
            //       items: [1,2,3,4,5].map((i) {
            //         return Builder(
            //           builder: (BuildContext context) {
            //             return ObjectCarouselCard(id: i);
            //           },
            //         );
            //       }).toList(),
            //     ),
            //   ),
            // ),
            // SliverPersistentHeader(
            //   pinned: false,
            //   delegate: _SliverAppBarDelegate(
            //     minHeight: 24,
            //     maxHeight: 24,
            //     child: Container(),
            //   ),
            // ),
            // SliverPersistentHeader(
            //   pinned: true,
            //   delegate: _SliverAppBarDelegate(
            //     minHeight: 45,
            //     maxHeight: 45,
            //     child: CustomTabContainer(
            //       firstTab: '????????????',
            //       secondTab: '??????????????????',
            //       currentIndex: currentIndexTab,
            //       onChange: (int index) {
            //         setState(() {
            //           currentIndexTab = index;
            //         });
            //       },
            //     ),
            //   ),
            // ),
          ];
        },
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44), vertical: 16),
                child: Column(
                  children: [
                    ContainerForTransition(
                      title: '?????????????? ???????????????????????????? ????????',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TotalCharts(
                            title: '?????????????? ???????????????????????????? ????????',
                          )),
                        );
                      },
                    ),
                    ContainerForTransition(
                      title: '?????????????? ?? ????????????????????????',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TotalCharts(
                            title: '?????????????? ?? ????????????????????????',
                          )),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
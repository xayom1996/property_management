import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/analytics/pages/analytics_page.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/authentication/pages/authorization_page.dart';
import 'package:property_management/characteristics/cubit/characteristics_cubit.dart';
import 'package:property_management/characteristics/pages/characteristics_page.dart';
import 'package:property_management/dashboard/cubit/dashboard_cubit.dart';
import 'package:property_management/exploitation/pages/exploitation_page.dart';
import 'package:property_management/objects/bloc/objects_bloc.dart';
import 'package:property_management/objects/pages/list_objects_page.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/total/pages/total_page.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';


class DashboardPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ObjectsBloc, ObjectsState>(
        listener: (context, state) {
        },
        buildWhen: (previousState, state) {
          return previousState.places != state.places;
        },
        builder: (context, state) {
          // print(state);
          if (state.status == ObjectsStatus.fetched){
            context.read<CharacteristicsCubit>().fetchObjects(state.places);
          }
          return Scaffold(
            // key: _scaffoldKey,
            body: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, dashboardState) {
                return SafeArea(
                  child: IndexedStack(
                    key: const PageStorageKey('Indexed'),
                    index: dashboardState.index,
                    children: context.read<DashboardCubit>().pages,
                  ),
                );
              },
            ),
            bottomNavigationBar: state.status == ObjectsStatus.fetched && state.places.isNotEmpty
                ? BlocBuilder<DashboardCubit, DashboardState>(
                    builder: (context, dashboardState) {
                      return MyNavBar(
                        currentIndex: dashboardState.index,
                        onTap: (DashboardItem dashboardItem) {
                          context.read<DashboardCubit>().getNavBarItem(dashboardItem);
                        },
                        items: const [
                          {
                            'iconPath': 'assets/icons/home.svg',
                            'title': 'Объекты',
                            'dashboardItem': DashboardItem.objects,
                          },
                          {
                            'iconPath': 'assets/icons/characteristic.svg',
                            'title': 'Характеристики',
                            'dashboardItem': DashboardItem.characteristics,
                          },
                          {
                            'iconPath': 'assets/icons/exploitation.svg',
                            'title': 'Эксплуатация',
                            'dashboardItem': DashboardItem.exploitation,
                          },
                          {
                            'iconPath': 'assets/icons/analytics.svg',
                            'title': 'Аналитика',
                            'dashboardItem': DashboardItem.analytics,
                          },
                          {
                            'iconPath': 'assets/icons/total.svg',
                            'title': 'Итоги',
                            'dashboardItem': DashboardItem.total,
                          },
                        ],
                      );
                    },
                  )
                : null,
          );
        }
    );
  }
}

class MyNavBar extends StatelessWidget{
  final List<Map> items;
  final int currentIndex;
  final Function(DashboardItem) onTap;

  MyNavBar({Key? key, required this.items, required this.currentIndex,
    required this.onTap}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        height: Platform.isIOS ? 90 : 80,
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
        // padding: EdgeInsets.only(left: horizontalPadding(context, 0.20.sw, portraitPadding: 0),
        //     right: horizontalPadding(context, 0.20.sw, portraitPadding: 0), bottom: Platform.isIOS ? 16 : 0),
        padding: EdgeInsets.only(top: 5, bottom: Platform.isIOS ? 16 : 0),
        child: Align(
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) =>
                Expanded(
                  flex: ScreenUtil().orientation == Orientation.portrait && 1.sw <= 750
                      ? 1
                      : 0,
                  child: InkWell(
                    onTap: (){
                      onTap(items[index]['dashboardItem']);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: index == items.length - 1
                          || ScreenUtil().orientation == Orientation.portrait && 1.sw <= 700
                          ? 0
                          : 1.sw <= 700
                            ? 16
                            : 32,
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
                            style: caption2.copyWith(
                              fontSize: MediaQuery.of(context).size.width < 800
                                  ? 10
                                  : 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            ),
          ),
        )
    );
  }

}

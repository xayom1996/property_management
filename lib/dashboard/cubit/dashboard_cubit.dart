import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:property_management/analytics/pages/analytics_page.dart';
import 'package:property_management/characteristics/pages/characteristics_page.dart';
import 'package:property_management/exploitation/pages/exploitation_page.dart';
import 'package:property_management/objects/pages/list_objects_page.dart';
import 'package:property_management/total/pages/total_charts.dart';
import 'package:property_management/total/pages/total_page.dart';

part 'dashboard_state.dart';

enum DashboardItem { objects, characteristics, exploitation, analytics, total }

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState(DashboardItem.objects, 0));

  List<Widget> pages = [
    const ListObjectsPage(),
    CharacteristicsPage(),
    ExploitationPage(),
    AnalyticsPage(),
    TotalCharts(),
    // ExploitationPage(),
    // AnalyticsPage(),
    // TotalPage(),
  ];
  void getNavBarItem(DashboardItem dashboardItem) {
    switch (dashboardItem) {
      case DashboardItem.objects:
        emit(const DashboardState(DashboardItem.objects, 0));
        break;
      case DashboardItem.characteristics:
        emit(const DashboardState(DashboardItem.characteristics, 1));
        break;
      case DashboardItem.exploitation:
        emit(const DashboardState(DashboardItem.exploitation, 2));
        break;
      case DashboardItem.analytics:
        emit(const DashboardState(DashboardItem.analytics, 3));
        break;
      case DashboardItem.total:
        emit(const DashboardState(DashboardItem.total, 4));
        break;
    }
  }
}

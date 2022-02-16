part of 'dashboard_cubit.dart';

class DashboardState extends Equatable {
  final DashboardItem dashboardItem;
  final int index;

  const DashboardState(this.dashboardItem, this.index);

  @override
  List<Object> get props => [dashboardItem, index];
}
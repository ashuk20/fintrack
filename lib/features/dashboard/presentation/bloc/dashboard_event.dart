part of 'dashboard_bloc.dart';

abstract class DashboardEvent {}

//fired when dashboard screen is opens
class DashboardStarted extends DashboardEvent {}

//fired when user pulls to  refresh
class DashboardRefreshed extends DashboardEvent {}

class DashboardBarTapped extends DashboardEvent {
  final String month;
  DashboardBarTapped(this.month);
}

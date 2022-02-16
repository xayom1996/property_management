import 'package:equatable/equatable.dart';
import 'package:property_management/account/models/user.dart';
import 'package:property_management/characteristics/cubit/characteristics_cubit.dart';
import 'package:property_management/characteristics/models/characteristics.dart';

enum AppStatus {
  loading,
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState({
    required this.status,
    this.user = User.empty,
    this.owners = const [],
    this.objectItems = const [],
    this.tenantItems = const [],
  });

  // const AppState.loading(User user, List<String> owners, List<Characteristics> objectItems, List<Characteristics> tenantItems)
  //     : this._(status: AppStatus.loading, user: user, owners: owners, objectItems: objectItems, tenantItems: tenantItems);
  //
  // const AppState.authenticated(User user, List<String> owners, List<Characteristics> objectItems, List<Characteristics> tenantItems)
  //     : this._(status: AppStatus.authenticated, user: user, owners: owners, objectItems: objectItems, tenantItems: tenantItems);
  //
  // const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User user;
  final List<String> owners;
  final List<Characteristics> objectItems;
  final List<Characteristics> tenantItems;

  @override
  List<Object> get props => [status, user, owners];

  AppState copyWith({
    AppStatus? status,
    User? user,
    List<String>? owners,
    List<Characteristics>? objectItems,
    List<Characteristics>? tenantItems,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
      owners: owners ?? this.owners,
      objectItems: objectItems ?? this.objectItems,
      tenantItems: tenantItems ?? this.tenantItems,
    );
  }
}
import 'package:equatable/equatable.dart';
import 'package:property_management/account/models/user.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = User.empty,
    this.owners = const [],
  });

  const AppState.authenticated(User user, List<String> owners)
      : this._(status: AppStatus.authenticated, user: user, owners: owners);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User user;
  final List<String> owners;

  @override
  List<Object> get props => [status, user, owners];
}
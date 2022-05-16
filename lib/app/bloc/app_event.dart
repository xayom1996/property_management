import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:property_management/account/models/user.dart';
import 'package:property_management/characteristics/models/characteristics.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppLogoutRequested extends AppEvent {}

class AppUserChanged extends AppEvent {
  @visibleForTesting
  const AppUserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class AppUserUpdated extends AppEvent {
  const AppUserUpdated(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class AppOwnerUpdated extends AppEvent {
  @visibleForTesting
  const AppOwnerUpdated(this.owners);

  final Map<String, dynamic> owners;

  @override
  List<Object> get props => [owners];
}

class AppConnectionUpdated extends AppEvent {
  @visibleForTesting
  const AppConnectionUpdated(this.hasConnection);

  final bool hasConnection;

  @override
  List<Object> get props => [hasConnection];
}
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:property_management/account/models/user.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppLogoutRequested extends AppEvent {}

class AppUserChanged extends AppEvent {
  @visibleForTesting
  const AppUserChanged(this.user, this.owners);

  final User user;
  final List<String> owners;

  @override
  List<Object> get props => [user, owners];
}

class AppUserUpdated extends AppEvent {
  const AppUserUpdated(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}
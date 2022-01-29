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
  const AppUserChanged(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class AppUserUpdated extends AppUserChanged {
  AppUserUpdated(User user) : super(user);
}
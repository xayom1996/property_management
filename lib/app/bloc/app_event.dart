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
  const AppUserChanged(this.user, this.owners, this.objectItems, this.tenantItems, this.expensesItems, this.expensesArticleItems);

  final User user;
  final List<String> owners;
  final List<Characteristics> objectItems;
  final List<Characteristics> tenantItems;
  final List<Characteristics> expensesItems;
  final List<Characteristics> expensesArticleItems;

  @override
  List<Object> get props => [user, owners, objectItems, tenantItems, expensesItems, expensesArticleItems];
}

class AppUserUpdated extends AppEvent {
  const AppUserUpdated(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}
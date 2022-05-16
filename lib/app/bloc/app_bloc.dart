import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:property_management/account/models/user.dart';
import 'package:property_management/app/bloc/app_event.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/app/services/firestore_service.dart';
import 'package:property_management/app/services/locator.dart';
import 'package:property_management/app/services/navigator_service.dart';
import 'package:property_management/app/services/user_repository.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/custom_alert_dialog.dart';
import 'package:property_management/authentication/cubit/auth/auth_cubit.dart';
import 'package:property_management/characteristics/models/characteristics.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required UserRepository userRepository, required FireStoreService fireStore,})
      : _userRepository = userRepository,
        fireStoreService = fireStore,
        super(
        const AppState(status: AppStatus.loading),
      ) {
          on<AppUserChanged>(_onUserChanged);
          on<AppUserUpdated>(_onUserUpdated);
          on<AppLogoutRequested>(_onLogoutRequested);
          on<AppOwnerUpdated>(_onOwnerUpdated);
          on<AppConnectionUpdated>(_onConnectionUpdated);
          _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
            bool hasConnection = await checkInternetConnection();
            add(AppConnectionUpdated(hasConnection));
          });

          _userSubscription = _userRepository.user.listen(
              (user) async {
                emit(state.copyWith(
                  status: AppStatus.loading,
                ));
                bool hasConnection = await checkInternetConnection();
                if (state.hasConnection != hasConnection) {
                  add(AppConnectionUpdated(hasConnection));
                }
                if (!hasConnection) {
                  return;
                }
                User _user = await _userRepository.getUser();
                add(AppUserChanged(_user));
              }
          );
        }

  final UserRepository _userRepository;
  final FireStoreService fireStoreService;
  late final StreamSubscription<User> _userSubscription;
  late final StreamSubscription _connectivitySubscription;

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) async {
    User _user = event.user;
    if (_user.isEmpty) {
      emit(state.copyWith(
        status: AppStatus.unauthenticated,
        user: _user,
        owners: {},
        planItems: [],
      ));
      return;
    }
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null && _user.isNotEmpty && _user.pushToken != fcmToken) {
      _user = _user.copyWith(pushToken: fcmToken);
      await _userRepository.updateUser(_user);
    }
    Map<String,
        Map<String,
            List<Characteristics>>> owners = await fireStoreService
        .getOwners(_user);
    List<Characteristics> planItems = await fireStoreService
        .getCharacteristics('plan_characteristics');

    emit(state.copyWith(
      status: AppStatus.authenticated,
      user: event.user,
      owners: owners,
      planItems: planItems,
    ));
  }

  void _onUserUpdated(AppUserUpdated event, Emitter<AppState> emit) async {
    emit(state.copyWith(
        status: AppStatus.loading,
    ));
    await _userRepository.updateUser(event.user);
    emit(state.copyWith(
      status: AppStatus.authenticated,
      user: event.user,
    ));
  }

  void _onOwnerUpdated(AppOwnerUpdated event, Emitter<AppState> emit) async {
    emit(state.copyWith(
      status: AppStatus.loading,
    ));
    emit(state.copyWith(
      status: AppStatus.authenticated,
      owners: event.owners,
    ));
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_userRepository.logOut());
  }

  void _onConnectionUpdated(AppConnectionUpdated event, Emitter<AppState> emit) async {
    BuildContext context = locator<NavigationService>().navigatorKey
        .currentState!.context;
    if (!event.hasConnection) {
      showDialog(
          context: context,
          builder: (context) =>
              CustomAlertDialog(
                title: 'Сервер не отвечает или нет соединения с интернетом',
                firstButtonTitle: 'Понятно',
                secondButtonTitle: null,
              )
      );
    } else {
      if (state.hasConnection == false) {
        User _user = await _userRepository.getUser();
        add(AppUserChanged(_user));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Интернет-соединение восстановлено'),
          duration: Duration(milliseconds: 1500),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Ok',
            textColor: Colors.white,
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        ));
      }
    }

    emit(state.copyWith(
        hasConnection: event.hasConnection
    ));
  }

  Future<bool> checkInternetConnection() async {
    bool hasConnection;
    try {
      final result = await InternetAddress.lookup('google.com').timeout(Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }
    return hasConnection;
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:property_management/account/models/user.dart';
import 'package:property_management/app/bloc/app_event.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/app/services/firestore_service.dart';
import 'package:property_management/app/services/user_repository.dart';
import 'package:property_management/characteristics/models/characteristics.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required UserRepository userRepository, required FireStoreService fireStore,})
      : _userRepository = userRepository,
        fireStoreService = fireStore,
        super(
        const AppState(status: AppStatus.unauthenticated),
      ) {
          on<AppUserChanged>(_onUserChanged);
          on<AppUserUpdated>(_onUserUpdated);
          on<AppLogoutRequested>(_onLogoutRequested);
          _userSubscription = _userRepository.user.listen(
              (user) async {
                emit(state.copyWith(
                  status: AppStatus.loading,
                ));
                User _user = await _userRepository.getUser();
                List<String> owners = await fireStoreService.getOwners(_user);
                List<Characteristics> objectItems = [];
                List<Characteristics> tenantItems = [];
                List<Characteristics> expensesItems = [];
                List<Characteristics> expensesArticleItems = [];
                List<Characteristics> planItems = [];

                // if (_user.isAdminOrManager()) {
                objectItems = await fireStoreService
                    .getCharacteristics('object_characteristics');
                tenantItems = await fireStoreService
                    .getCharacteristics('tenant_characteristics');
                expensesItems = await fireStoreService
                    .getCharacteristics('expense_characteristics');
                expensesArticleItems = await fireStoreService
                    .getCharacteristics('expense_article_characteristics');
                planItems = await fireStoreService
                    .getCharacteristics('plan_characteristics');
                // }
                add(AppUserChanged(_user, owners, objectItems, tenantItems,
                    expensesItems, expensesArticleItems, planItems));
              },
          );
          // _userRepository.getObjects(state.user);
        }

  final UserRepository _userRepository;
  final FireStoreService fireStoreService;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) async {
    emit(state.copyWith(
      status: event.user.isEmpty
          ? AppStatus.unauthenticated
          : AppStatus.authenticated,
      user: event.user,
      owners: event.owners,
      objectItems: event.objectItems,
      tenantItems: event.tenantItems,
      expensesItems: event.expensesItems,
      expensesArticleItems: event.expensesArticleItems,
      planItems: event.planItems,
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

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_userRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
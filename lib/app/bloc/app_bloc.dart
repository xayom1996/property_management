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
  AppBloc({required UserRepository userRepository, required FireStoreService fireStoreService,})
      : _userRepository = userRepository,
        _fireStoreService = fireStoreService,
        super(
        // userRepository.currentUser.isNotEmpty
        //     ? AppState.authenticated(userRepository.currentUser)
        const AppState.unauthenticated(),
      ) {
          on<AppUserChanged>(_onUserChanged);
          on<AppUserUpdated>(_onUserUpdated);
          on<AppLogoutRequested>(_onLogoutRequested);
          _userSubscription = _userRepository.user.listen(
              (user) async {
                User _user = await _userRepository.getUser();
                List<String> owners = await _fireStoreService.getOwners(_user);
                List<Characteristics> objectItems = [];
                List<Characteristics> tenantItems = [];
                if (_user.isAdminOrManager()) {
                  objectItems = await _fireStoreService
                      .getCharacteristics('object_characteristics');
                  tenantItems = await _fireStoreService
                      .getCharacteristics('tenant_characteristics');
                }
                add(AppUserChanged(_user, owners, objectItems, tenantItems));
              },
          );
          // _userRepository.getObjects(state.user);
        }

  final UserRepository _userRepository;
  final FireStoreService _fireStoreService;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) async {
    if (event.user.isEmpty) {
      emit(const AppState.unauthenticated());
    } else {
      emit(AppState.authenticated(event.user, event.owners, event.objectItems, event.tenantItems));
    }
  }

  void _onUserUpdated(AppUserUpdated event, Emitter<AppState> emit) async {
    await _userRepository.updateUser(event.user);
    emit(AppState.authenticated(event.user, state.owners, state.objectItems, state.tenantItems));
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
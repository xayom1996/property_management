import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_management/account/models/user.dart';
import 'package:property_management/authentication/bloc/authentication_event.dart';
import 'package:property_management/authentication/bloc/authentication_state.dart';
import 'package:property_management/utils/user_repository.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(
        // userRepository.currentUser.isNotEmpty
        //     ? AppState.authenticated(userRepository.currentUser)
        const AppState.unauthenticated(),
      ) {
          on<AppUserChanged>(_onUserChanged);
          on<AppLogoutRequested>(_onLogoutRequested);
          _userSubscription = _userRepository.user.listen(
                (user) => add(AppUserChanged(user)),
          );
        }

  final UserRepository _userRepository;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) async {
    emit(event.user.isNotEmpty
        ? AppState.authenticated(await _userRepository.getUser())
        : const AppState.unauthenticated());
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
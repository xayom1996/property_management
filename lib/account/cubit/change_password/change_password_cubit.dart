import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:property_management/app/services/user_repository.dart';
import 'package:property_management/authentication/form_inputs/password.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this._userRepository) : super(const ChangePasswordState());

  final UserRepository _userRepository;

  void initialState() {
    emit(state.copyWith(
      newPassword: const Password.pure(),
      currentPassword: const Password.pure(),
      status: FormzStatus.pure,
    ));
  }

  void currentPasswordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      currentPassword: password,
      status: Formz.validate([password, state.newPassword]),
    ));
  }

  void newPasswordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      newPassword: password,
      status: Formz.validate([state.currentPassword, password]),
    ));
  }

  Future<void> changePassword() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _userRepository.changePassword(state.currentPassword.value, state.newPassword.value);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
      emit(state.copyWith(
        newPassword: const Password.pure(),
        currentPassword: const Password.pure(),
        status: FormzStatus.pure,
      ));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
        errorMessage: e.message,
        status: FormzStatus.submissionFailure,
      ));
    } catch (e) {
      print('Ошибка');
      print(e);
    }
  }
}

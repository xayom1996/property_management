import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:property_management/app/utils/user_repository.dart';
import 'package:property_management/authentication/form_inputs/email.dart';

part 'recovery_password_state.dart';

class RecoveryPasswordCubit extends Cubit<RecoveryPasswordState> {
  RecoveryPasswordCubit(this._userRepository) : super(const RecoveryPasswordState());

  final UserRepository _userRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([email]),
    ));
  }

  Future<void> resetPassword() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _userRepository.resetPassword(state.email.value);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
      emit(state.copyWith(
        email: const Email.pure(),
        status: FormzStatus.pure,
      ));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
        errorMessage: 'Ошибка',
        status: FormzStatus.submissionFailure,
      ));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}

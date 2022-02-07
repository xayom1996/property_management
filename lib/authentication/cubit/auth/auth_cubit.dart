import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:hive/hive.dart';
import 'package:property_management/app/services/user_repository.dart';
import 'package:property_management/authentication/form_inputs/email.dart';
import 'package:property_management/authentication/form_inputs/password.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._userRepository) : super(const AuthState());

  final UserRepository _userRepository;

  void initialState() {
    emit(state.copyWith(
      email: const Email.pure(),
      password: const Password.pure(),
      status: FormzStatus.pure,
    ));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      // status: FormzStatus.valid,
      status: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      // status: FormzStatus.valid,
      status: Formz.validate([state.email, password]),
    ));
  }

  Future<void> logIn({String? email, String? password, bool addNewAccount = false}) async {
    // if (state.email.invalid){
    //   emit(state.copyWith(
    //     errorMessage: 'Введите корректный почтовый адрес',
    //     status: FormzStatus.submissionFailure,
    //   ));
    //   return;
    // }
    if (email == null && password == null && !state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _userRepository.logInWithEmailAndPassword(
        email: email ?? state.email.value,
        password: password ?? state.password.value,
      );
      var box = await Hive.openBox('accountsBox');
      if (addNewAccount == true) {
        Map accounts;
        if (box.get('accounts') != null) {
          accounts = box.get('accounts');
        } else {
          accounts = {};
        }
        if (accounts[state.email.value] == null) {
          accounts[state.email.value] = {
            'email': state.email.value,
            'password': state.password.value,
          };
        }
        box.put('accounts', accounts);
      }
      else{
        box.put('account', {
          'email': email ?? state.email.value,
          'password': password ?? state.password.value,
        });

      }
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
      emit(state.copyWith(
        email: const Email.pure(),
        password: const Password.pure(),
        status: FormzStatus.pure,
      ));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(
        errorMessage: e.message,
        status: FormzStatus.submissionFailure,
      ));
    } catch (_) {
      print(_);
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}

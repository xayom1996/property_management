part of 'change_password_cubit.dart';

class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.currentPassword = const Password.pure(),
    this.newPassword = const Password.pure(),
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final Password currentPassword;
  final Password newPassword;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props => [currentPassword, newPassword, status];

  ChangePasswordState copyWith({
    Password? currentPassword,
    Password? newPassword,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return ChangePasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

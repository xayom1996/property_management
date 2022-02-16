import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/account/models/user.dart';
import 'package:property_management/app/services/user_repository.dart';

part 'personal_info_state.dart';

class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  PersonalInfoCubit(this._userRepository) : super(PersonalInfoInitial());

  final UserRepository _userRepository;

  void updateUser({String}) {
    // emit(state.copyWith(user: user));
  }
}

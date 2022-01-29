part of 'personal_info_cubit.dart';

abstract class PersonalInfoState extends Equatable {
  const PersonalInfoState();
}

class PersonalInfoInitial extends PersonalInfoState {
  @override
  List<Object> get props => [];
}

class PersonalInfoSuccessfullySaved extends PersonalInfoState{
  @override
  List<Object?> get props => [];
}

class PersonalInfoErrorSaved extends PersonalInfoState{
  @override
  List<Object?> get props => [];
}
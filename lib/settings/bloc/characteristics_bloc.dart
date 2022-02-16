import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/app/services/user_repository.dart';

part 'characteristics_event.dart';
part 'characteristics_state.dart';

class CharacteristicsBloc extends Bloc<CharacteristicsEvent, CharacteristicsState> {
  CharacteristicsBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(CharacteristicsInitial()) {
        on<CharacteristicsEvent>((event, emit) {
          // TODO: implement event handler
        });
      }

  final UserRepository _userRepository;
}

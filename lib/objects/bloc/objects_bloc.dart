import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/account/models/user.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_event.dart';
import 'package:property_management/app/services/firestore_service.dart';
import 'package:property_management/app/services/user_repository.dart';
import 'package:property_management/objects/models/place.dart';

part 'objects_event.dart';
part 'objects_state.dart';

class ObjectsBloc extends Bloc<ObjectsEvent, ObjectsState> {
  ObjectsBloc({required FireStoreService fireStoreService,
    required UserRepository userRepository})
      : _fireStoreService = fireStoreService,
       _userRepository = userRepository,
        super(const ObjectsState.initial()) {
        on<ObjectsGetEvent>(_onGetObjects);
        _userSubscription = _userRepository.user.listen(
              (user) => add(ObjectsGetEvent()),
        );
      }

  final FireStoreService _fireStoreService;
  final UserRepository _userRepository;
  late StreamSubscription _userSubscription;


  void _onGetObjects(ObjectsEvent event, Emitter<ObjectsState> emit) async {
    emit(const ObjectsState.loading());
    // await _fireStoreService.addObject();
    List<Place> places = await _fireStoreService.getObjects(await _userRepository.getUser());
    print(places);
    emit(ObjectsState.fetched(places));
  }
}

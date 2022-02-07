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
    required AppBloc appBloc})
      : _fireStoreService = fireStoreService,
        _appBloc = appBloc,
        super(const ObjectsState.initial()) {
        on<ObjectsGetEvent>(_onGetObjects);
        on<GetFilteredObjectsEvent>(_onGetFilteredObjects);
        on<ChangeFilterObjectsEvent>(_onChangeFilterObjects);
        on<DeleteObjectEvent>(_onDeleteObject);
        _appBlocSubscription = _appBloc.stream.listen(
              (state){
                add(ObjectsGetEvent(user: state.user, owners: state.owners));
              });
      }

  final FireStoreService _fireStoreService;
  final AppBloc _appBloc;
  late StreamSubscription _appBlocSubscription;


  void _onGetObjects(ObjectsGetEvent event, Emitter<ObjectsState> emit) async {
    emit(const ObjectsState.loading());
    List<Place> places = await _fireStoreService.getObjects(event.user, event.owners);
    places.sort((a, b) => a.objectItems['Название объекта']!.value!.compareTo(b.objectItems['Название объекта']!.value!));
    emit(ObjectsState.fetched(places, 'name'));
  }

  void _onGetFilteredObjects(GetFilteredObjectsEvent event, Emitter<ObjectsState> emit) async {
    List<Place> places = state.places;
    String filterBy = state.filterBy;
    String filterField = 'Название объекта';
    if (filterBy == 'address'){
      filterField = 'Адрес объекта';
    }
    emit(const ObjectsState.loading());
    places.sort((a, b) => a.objectItems[filterField]!.value!.compareTo(b.objectItems[filterField]!.value!));
    emit(ObjectsState.fetched(places, filterBy));
  }

  void _onChangeFilterObjects(ChangeFilterObjectsEvent event, Emitter<ObjectsState> emit) async {
    emit(ObjectsState.fetched(state.places, event.filterBy));
  }

  void _onDeleteObject(DeleteObjectEvent event, Emitter<ObjectsState> emit) async {
    List<Place> places = state.places;
    String filterBy = state.filterBy;
    emit(const ObjectsState.loading());
    print(state);
    places.removeAt(event.index);
    emit(ObjectsState.fetched(places, filterBy));
  }
}

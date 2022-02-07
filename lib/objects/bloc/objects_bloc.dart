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
        super(const ObjectsState()) {
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
    emit(state.copyWith(status: ObjectsStatus.loading));
    List<Place> places;
    if (event.user.isEmpty) {
      places = [];
    } else {
      places = await _fireStoreService.getObjects(event.user, event.owners);
    }
    String filterBy = state.filterBy;
    String filterField = 'Название объекта';
    if (filterBy == 'address'){
      filterField = 'Адрес объекта';
    }
    places.sort((a, b) => a.objectItems[filterField]!.value!.compareTo(b.objectItems[filterField]!.value!));
    emit(state.copyWith(status: ObjectsStatus.fetched, places: places, filterBy: 'name'));
  }

  void _onGetFilteredObjects(GetFilteredObjectsEvent event, Emitter<ObjectsState> emit) async {
    List<Place> places = state.places;
    String filterBy = state.filterBy;
    String filterField = 'Название объекта';
    if (filterBy == 'address'){
      filterField = 'Адрес объекта';
    }
    emit(state.copyWith(status: ObjectsStatus.loading));
    places.sort((a, b) => a.objectItems[filterField]!.value!.compareTo(b.objectItems[filterField]!.value!));
    emit(state.copyWith(status: ObjectsStatus.fetched, places: places, filterBy: filterBy));
  }

  void _onChangeFilterObjects(ChangeFilterObjectsEvent event, Emitter<ObjectsState> emit) async {
    emit(state.copyWith(status: ObjectsStatus.fetched, filterBy: event.filterBy));
  }

  void _onDeleteObject(DeleteObjectEvent event, Emitter<ObjectsState> emit) async {
    List<Place> places = state.places;
    emit(state.copyWith(status: ObjectsStatus.loading));
    try{
      await _fireStoreService.deleteObject(places[event.index].id);
      places.removeAt(event.index);
      emit(state.copyWith(status: ObjectsStatus.fetched, places: places));
    } catch(e) {
      print(e);
    }
    emit(state.copyWith(status: ObjectsStatus.fetched));
  }
}

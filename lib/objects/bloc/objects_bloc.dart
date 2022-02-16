import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/account/models/user.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_event.dart';
import 'package:property_management/app/bloc/app_state.dart';
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
        on<ChangeColorObjectEvent>(_onChangeColorObjectEvent);
        on<DeleteObjectEvent>(_onDeleteObject);
        _appBlocSubscription = _appBloc.stream.listen(
              (state){
                if (state.status != AppStatus.loading) {
                  add(ObjectsGetEvent(user: state.user, owners: state.owners));
                }
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
      return emit(state.copyWith(status: ObjectsStatus.initial, places: places, filterBy: 'name'));
    } else {
      places = await _fireStoreService.getObjects(event.user, event.owners);
    }
    String filterBy = state.filterBy;
    String filterField = 'Название объекта';
    if (filterBy == 'address'){
      filterField = 'Адрес объекта';
    }
    places.sort((a, b) =>
        a.objectItems[filterField]!.getFullValue().toLowerCase()
            .compareTo(b.objectItems[filterField]!.getFullValue().toLowerCase())
    );
    emit(state.copyWith(status: ObjectsStatus.fetched, places: places, filterBy: filterBy));
  }

  void _onGetFilteredObjects(GetFilteredObjectsEvent event, Emitter<ObjectsState> emit) async {
    emit(state.copyWith(status: ObjectsStatus.loading));
    List<Place> places = state.places;
    String filterBy = event.filterBy;
    String filterField = 'Название объекта';
    if (filterBy == 'address'){
      filterField = 'Адрес объекта';
    }
    places.sort((a, b) =>
        a.objectItems[filterField]!.getFullValue().toLowerCase()
            .compareTo(b.objectItems[filterField]!.getFullValue().toLowerCase())
    );
    emit(state.copyWith(status: ObjectsStatus.fetched, places: places, filterBy: filterBy));
  }

  void _onChangeColorObjectEvent(ChangeColorObjectEvent event, Emitter<ObjectsState> emit) async {
    try {
      await _fireStoreService.updateColorObject(
          docId: state.places[event.id].id, value: event.value);
      add(ObjectsGetEvent(user: _appBloc.state.user, owners: _appBloc.state.owners));
    }catch(e){

    }
  }

  void _onChangeFilterObjects(ChangeFilterObjectsEvent event, Emitter<ObjectsState> emit) async {
    emit(state.copyWith(status: ObjectsStatus.fetched, filterBy: event.filterBy));
  }

  void _onDeleteObject(DeleteObjectEvent event, Emitter<ObjectsState> emit) async {
    emit(state.copyWith(status: ObjectsStatus.loading));
    try{
      int? index = event.index;
      if (event.index == null) {
        index = state.places.indexWhere((element) => element.id == event.docId);
      }
      List<Place> places = state.places;
      await _fireStoreService.deleteObject(places[index!].id);
      places.removeAt(index);
      emit(state.copyWith(status: ObjectsStatus.fetched, places: places));
    } catch(e) {
      print(e);
    }
    emit(state.copyWith(status: ObjectsStatus.fetched));
  }
}

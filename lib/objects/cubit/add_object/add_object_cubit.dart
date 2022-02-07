import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/services/firestore_service.dart';
import 'package:property_management/characteristics/models/characteristics.dart';

part 'add_object_state.dart';

class AddObjectCubit extends Cubit<AddObjectState> {
  AddObjectCubit({required FireStoreService fireStoreService, required AppBloc appBloc})
      : _fireStoreService = fireStoreService,
        _appBloc = appBloc,
        super(AddObjectState()) {
          getItems(_appBloc.state.objectItems);
          _appBlocSubscription = _appBloc.stream.listen(
                  (state){
                    getItems(state.objectItems);
                  });
        }

  final FireStoreService _fireStoreService;
  final AppBloc _appBloc;
  late StreamSubscription _appBlocSubscription;

  void getItems(List<Characteristics> items) async {
    List<Characteristics> _addItems = List.from(items.map((item) => Characteristics.fromJson(item.toJson())));
    emit(AddObjectState(
      addItems: _addItems,
      items: items,
    ));
  }

  void getOwners() async {

  }

  bool isObjectItemsValid(List<Characteristics> items) {
    return items[0].getFullValue().isNotEmpty && items[1].getFullValue().isNotEmpty
    && items[2].getFullValue().isNotEmpty && items[3].getFullValue().isNotEmpty;
  }

  void changeItemValue(int id, String value) {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    List<Characteristics> _addItems = [];
    for (var item in state.addItems) {
      _addItems.add(item);
    }
    _addItems[id].value = value;
    emit(state.copyWith(
      addItems: _addItems,
      status: isObjectItemsValid(_addItems)
          ? StateStatus.valid
          : StateStatus.invalid,
    ));
  }

  void addObject() async {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    try {
      await _fireStoreService.addObject(filledItems: state.addItems);
      List<Characteristics> _addItems = List.from(state.items.map((item) => Characteristics.fromJson(item.toJson())));
      emit(state.copyWith(
        addItems: _addItems,
        status: StateStatus.success,
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(
        status: StateStatus.error,
      ));
    }
  }
}

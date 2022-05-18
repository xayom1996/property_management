import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/app/services/firestore_service.dart';
import 'package:property_management/characteristics/models/characteristics.dart';

part 'add_object_state.dart';

class AddObjectCubit extends Cubit<AddObjectState> {
  AddObjectCubit({required FireStoreService fireStoreService, required AppBloc appBloc})
      : _fireStoreService = fireStoreService,
        _appBloc = appBloc,
        super(AddObjectState()) {

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

  bool isObjectItemsValid(List<Characteristics> items) {
    return items[0].getFullValue().isNotEmpty && items[1].getFullValue().isNotEmpty
        && items[2].getFullValue().isNotEmpty && items[3].getFullValue().isNotEmpty
        && items[6].getFullValue().isNotEmpty && items[7].getFullValue().isNotEmpty
        && items[15].getFullValue().isNotEmpty && items[15].value != '0';
  }

  bool isRequired(int index) {
    List listRequiredIds = [0, 1, 2, 3, 6, 7, 15];
    return listRequiredIds.contains(index);
  }

  bool showInCreating(Characteristics item) {
    return item.id != 8 && item.id != 13;
  }

  void changeItemValue(int id, String value, String documentUrl) {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    List<Characteristics> addItems = state.addItems;
    int index = addItems.lastIndexWhere((element) => element.id == id);
    addItems[index].value = value;
    addItems[index].documentUrl = documentUrl;
    // if (id == 13 || id == 14) { //Арендная плата или коэфициент капитализации
    //   if (_addItems[13].getFullValue().isNotEmpty && _addItems[14].getFullValue().isNotEmpty) {
    //     _addItems[15].value = (double.parse(_addItems[13].value!) ~/ double.parse(_addItems[14].value!)).toString();
    //   } else {
    //     _addItems[15].value = '';
    //   }
    // }
    emit(state.copyWith(
      addItems: addItems,
      status: isObjectItemsValid(addItems)
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

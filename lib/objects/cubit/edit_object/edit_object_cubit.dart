import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/services/firestore_service.dart';
import 'package:property_management/characteristics/models/characteristics.dart';
import 'package:property_management/objects/cubit/add_object/add_object_cubit.dart';

part 'edit_object_state.dart';

class EditObjectCubit extends Cubit<EditObjectState> {
  EditObjectCubit({required FireStoreService fireStoreService})
      : _fireStoreService = fireStoreService,
        super(const EditObjectState());

  final FireStoreService _fireStoreService;

  void getItems(Map<String, Characteristics> objectItems, String docId) async {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    List<Characteristics> _items = List<Characteristics>.from(objectItems.values.map((item) => item));
    _items.sort((a, b) => a.id.compareTo(b.id));
    emit(state.copyWith(
      items: _items,
      docId: docId,
      status: isObjectItemsValid(_items)
          ? StateStatus.valid
          : StateStatus.invalid,
    ));
  }

  bool isObjectItemsValid(List<Characteristics> items) {
    return items[0].getFullValue().isNotEmpty && items[1].getFullValue().isNotEmpty
        && items[2].getFullValue().isNotEmpty && items[3].getFullValue().isNotEmpty;
  }

  void changeItemValue(int id, String value, String documentUrl) {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    List<Characteristics> _items = List<Characteristics>.from(state.items.map((item) => item));
    _items[id].value = value;
    _items[id].documentUrl = documentUrl;
    emit(state.copyWith(
      items: _items,
      status: isObjectItemsValid(_items)
          ? StateStatus.valid
          : StateStatus.invalid,
    ));
  }

  void editObject() async {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    try {
      await _fireStoreService.editObject(filledItems: state.items, docId: state.docId);
      emit(state.copyWith(
        status: StateStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.error,
      ));
    }
  }
}

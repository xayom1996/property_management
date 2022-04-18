import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/app/cubit/adding/adding_state.dart';
import 'package:property_management/app/cubit/editing/editing_state.dart';
import 'package:property_management/app/services/firestore_service.dart';
import 'package:property_management/characteristics/models/characteristics.dart';

class EditPlanCubit extends Cubit<EditingState> {
  EditPlanCubit({required FireStoreService fireStoreService})
      : _fireStoreService = fireStoreService,
        super(const EditingState());

  final FireStoreService _fireStoreService;

  void getItems(Map<String, Characteristics> planItems, String docId) async {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));

    List<Characteristics> _items = List.from(planItems.values.map((item) => Characteristics.fromJson(item.toJson())));

    _items.sort((a, b) => a.id.compareTo(b.id));
    emit(state.copyWith(
      items: _items,
      docId: docId,
      status: isItemsValid(_items)
          ? StateStatus.valid
          : StateStatus.invalid,
    ));
  }

  bool isItemsValid(List<Characteristics> items) {
    for (var item in items) {
      if (item.getFullValue().isEmpty && !item.title.contains('Потери от недогрузки')) {
        return false;
      }
    }
    return true;
  }

  void changeItemValue(int id, String value) {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    List<Characteristics> _items = List<Characteristics>.from(state.items.map((item) => item));
    _items[id].value = value;
    emit(state.copyWith(
      items: _items,
      status: isItemsValid(_items)
          ? StateStatus.valid
          : StateStatus.invalid,
    ));
  }

  void edit(int planIndex, {String action = 'edit'}) async {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    try {
      await _fireStoreService.addPlan(planItems: state.items, docId: state.docId,
          action: action, index: planIndex);
      emit(state.copyWith(
        // addItems: _addItems,
        status: StateStatus.success,
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(
        status: StateStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}

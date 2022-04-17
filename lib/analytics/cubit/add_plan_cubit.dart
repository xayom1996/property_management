import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/app/cubit/adding/adding_state.dart';
import 'package:property_management/app/services/firestore_service.dart';
import 'package:property_management/characteristics/models/characteristics.dart';

// part 'add_tenant_state.dart';

class AddPlanCubit extends Cubit<AddingState> {
  AddPlanCubit({required FireStoreService fireStoreService, required AppBloc appBloc})
      : _fireStoreService = fireStoreService,
        _appBloc = appBloc,
        super(AddingState()) {
          getItems(_appBloc.state.expensesItems);
          _appBlocSubscription = _appBloc.stream.listen(
                  (state){
                    if (state.status != AppStatus.loading) {
                      getItems(state.expensesItems);
                    }
                  });
        }

  final FireStoreService _fireStoreService;
  final AppBloc _appBloc;
  late StreamSubscription _appBlocSubscription;

  void getItems(List<Characteristics> items) async {
    List<Characteristics> _addItems = List.from(items.map((item) => Characteristics.fromJson(item.toJson())));
    emit(AddingState(
      addItems: _addItems,
      items: items,
      status: isItemsValid(_addItems)
          ? StateStatus.valid
          : StateStatus.invalid,
    ));
  }

  bool isItemsValid(List<Characteristics> items) {
    return items[0].getFullValue().isNotEmpty;
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
      status: isItemsValid(_addItems)
          ? StateStatus.valid
          : StateStatus.invalid,
    ));
  }

  void add(String docId) async {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    try {
      await _fireStoreService.addExpense(expenseItems: state.addItems, docId: docId,
          defaultExpenseItems: _appBloc.state.expensesItems);
      List<Characteristics> _addItems = List.from(state.items.map((item) => Characteristics.fromJson(item.toJson())));
      emit(state.copyWith(
        addItems: _addItems,
        status: StateStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StateStatus.error,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}

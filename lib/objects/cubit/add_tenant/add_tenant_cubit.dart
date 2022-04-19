import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/app/cubit/adding/adding_state.dart';
import 'package:property_management/app/services/firestore_service.dart';
import 'package:property_management/characteristics/models/characteristics.dart';

// part 'add_tenant_state.dart';

class AddTenantCubit extends Cubit<AddingState> {
  AddTenantCubit({required FireStoreService fireStoreService, required AppBloc appBloc})
      : _fireStoreService = fireStoreService,
        _appBloc = appBloc,
        super(AddingState()) {
          getItems(_appBloc.state.tenantItems);
          _appBlocSubscription = _appBloc.stream.listen(
                  (state){
                    if (state.status != AppStatus.loading) {
                      getItems(state.tenantItems);
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
    ));
  }

  bool isTenantItemsValid(List<Characteristics> items) {
    return true;
  }

  void changeItemValue(int id, String value, String documentUrl) {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    List<Characteristics> _addItems = [];
    for (var item in state.addItems) {
      _addItems.add(item);
    }
    _addItems[id].value = value;
    _addItems[id].documentUrl = documentUrl;
    emit(state.copyWith(
      addItems: _addItems,
      status: isTenantItemsValid(_addItems)
          ? StateStatus.valid
          : StateStatus.invalid,
    ));
  }

  void changeDetails(int id, List<String> details, String documentUrl) {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    List<Characteristics> _addItems = [];
    for (var item in state.addItems) {
      _addItems.add(item);
    }
    _addItems[id].details = details;
    _addItems[id].documentUrl = documentUrl;
    emit(state.copyWith(
      addItems: _addItems,
      status: isTenantItemsValid(_addItems)
          ? StateStatus.valid
          : StateStatus.invalid,
    ));
  }

  void addTenant(String docId) async {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    try {
      await _fireStoreService.addTenant(tenantItems: state.addItems, docId: docId);
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

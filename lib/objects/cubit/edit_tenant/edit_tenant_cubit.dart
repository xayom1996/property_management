import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/app/services/firestore_service.dart';
import 'package:property_management/characteristics/models/characteristics.dart';
import 'package:property_management/objects/cubit/add_tenant/add_tenant_cubit.dart';

part 'edit_tenant_state.dart';

class EditTenantCubit extends Cubit<EditTenantState> {
  EditTenantCubit({required FireStoreService fireStoreService})
      : _fireStoreService = fireStoreService,
        super(const EditTenantState());

  final FireStoreService _fireStoreService;

  void getItems(Map<String, Characteristics> tenantItems, String docId) async {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    List<Characteristics> _items = List<Characteristics>.from(tenantItems.values.map((item) => item));
    _items.sort((a, b) => a.id.compareTo(b.id));
    emit(state.copyWith(
      items: _items,
      docId: docId,
      status: isTenantItemsValid(_items)
          ? StateStatus.valid
          : StateStatus.invalid,
    ));
  }

  bool isTenantItemsValid(List<Characteristics> items) {
    return items[0].getFullValue().isNotEmpty;
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
      status: isTenantItemsValid(_items)
          ? StateStatus.valid
          : StateStatus.invalid,
    ));
  }

  void changeDetails(int id, List<String> details) {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    List<Characteristics> _items = List<Characteristics>.from(state.items.map((item) => item));
    _items[id].details = details;
    emit(state.copyWith(
      items: _items,
      status: isTenantItemsValid(_items)
          ? StateStatus.valid
          : StateStatus.invalid,
    ));
  }

  void editTenant() async {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    try {
      await _fireStoreService.editTenant(filledItems: state.items, docId: state.docId);
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
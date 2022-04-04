import 'package:bloc/bloc.dart';
import 'package:property_management/app/cubit/adding/adding_state.dart';
import 'package:property_management/app/cubit/editing/editing_state.dart';
import 'package:property_management/app/services/firestore_service.dart';
import 'package:property_management/characteristics/models/characteristics.dart';

// part 'edit_tenant_state.dart';

class EditTenantCubit extends Cubit<EditingState> {
  EditTenantCubit({required FireStoreService fireStoreService})
      : _fireStoreService = fireStoreService,
        super(const EditingState());

  final FireStoreService _fireStoreService;

  void getItems(Map<String, Characteristics> tenantItems, String docId) async {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    List<Characteristics> _items = List<Characteristics>.from(tenantItems.values.map((item) => Characteristics.fromJson(item.toJson())));
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
    print(id);
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

  void changeDetails(int id, List<String> details, String documentUrl) {
    emit(state.copyWith(
      status: StateStatus.loading,
    ));
    List<Characteristics> _items = List<Characteristics>.from(state.items.map((item) => item));
    _items[id].details = details;
    _items[id].documentUrl = documentUrl;
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

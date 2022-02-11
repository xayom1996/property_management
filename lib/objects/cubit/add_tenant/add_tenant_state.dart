part of 'add_tenant_cubit.dart';

enum StateStatus {
  initial,
  loading,
  valid,
  invalid,
  success,
  error,
}

class AddTenantState extends Equatable {
  const AddTenantState({
      this.items = const [],
      this.addItems = const [],
      this.status = StateStatus.initial,
  });

  final List<Characteristics> items;
  final List<Characteristics> addItems;
  final StateStatus status;

  @override
  List<Object> get props => [items, addItems, status];

  AddTenantState copyWith({
    List<Characteristics>? items,
    List<Characteristics>? addItems,
    StateStatus? status,
  }) {
    return AddTenantState(
      items: items ?? this.items,
      addItems: addItems ?? this.addItems,
      status: status ?? this.status,
    );
  }
}

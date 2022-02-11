part of 'edit_tenant_cubit.dart';

class EditTenantState extends Equatable {
  const EditTenantState({
    this.items = const [],
    this.docId = '',
    this.status = StateStatus.initial,
  });

  final List<Characteristics> items;
  final String docId;
  final StateStatus status;

  @override
  List<Object> get props => [items, status, docId];

  EditTenantState copyWith({
    List<Characteristics>? items,
    String? docId,
    StateStatus? status,
  }) {
    return EditTenantState(
      items: items ?? this.items,
      docId: docId ?? this.docId,
      status: status ?? this.status,
    );
  }
}

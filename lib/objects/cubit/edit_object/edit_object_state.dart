part of 'edit_object_cubit.dart';

class EditObjectState extends Equatable {
  const EditObjectState({
    this.items = const [],
    this.docId = '',
    this.status = StateStatus.initial,
  });

  final List<Characteristics> items;
  final String docId;
  final StateStatus status;

  @override
  List<Object> get props => [items, status, docId];

  EditObjectState copyWith({
    List<Characteristics>? items,
    String? docId,
    StateStatus? status,
  }) {
    return EditObjectState(
      items: items ?? this.items,
      docId: docId ?? this.docId,
      status: status ?? this.status,
    );
  }
}

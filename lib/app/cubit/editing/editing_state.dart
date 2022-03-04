import 'package:equatable/equatable.dart';
import 'package:property_management/app/cubit/adding/adding_state.dart';
import 'package:property_management/characteristics/models/characteristics.dart';

class EditingState extends Equatable {
  const EditingState({
    this.items = const [],
    this.docId = '',
    this.status = StateStatus.initial,
  });

  final List<Characteristics> items;
  final String docId;
  final StateStatus status;

  @override
  List<Object> get props => [items, status, docId];

  EditingState copyWith({
    List<Characteristics>? items,
    String? docId,
    StateStatus? status,
  }) {
    return EditingState(
      items: items ?? this.items,
      docId: docId ?? this.docId,
      status: status ?? this.status,
    );
  }
}

part of 'add_object_cubit.dart';

enum StateStatus {
  initial,
  loading,
  success,
  error,
}

class AddObjectState extends Equatable {
  AddObjectState({
      this.items = const [],
      this.addItems = const [],
      this.status = StateStatus.initial,
  });

  final List<Characteristics> items;
  final List<Characteristics> addItems;
  final StateStatus status;

  @override
  List<Object> get props => [items, addItems, status];

  AddObjectState copyWith({
    List<Characteristics>? items,
    List<Characteristics>? addItems,
    StateStatus? status,
  }) {
    return AddObjectState(
      items: items ?? this.items,
      addItems: addItems ?? this.addItems,
      status: status ?? this.status,
    );
  }
}

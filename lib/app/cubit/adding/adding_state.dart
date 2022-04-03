import 'package:equatable/equatable.dart';
import 'package:property_management/characteristics/models/characteristics.dart';

enum StateStatus {
  initial,
  loading,
  valid,
  invalid,
  success,
  error,
}

class AddingState extends Equatable {
  AddingState({
      this.items = const [],
      this.addItems = const [],
      this.status = StateStatus.initial,
      this.errorMessage = '',
  });

  final List<Characteristics> items;
  final List<Characteristics> addItems;
  final StateStatus status;
  final String errorMessage;

  @override
  List<Object> get props => [items, addItems, status, errorMessage];

  AddingState copyWith({
    List<Characteristics>? items,
    List<Characteristics>? addItems,
    StateStatus? status,
    String? errorMessage,
  }) {
    return AddingState(
      items: items ?? this.items,
      addItems: addItems ?? this.addItems,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

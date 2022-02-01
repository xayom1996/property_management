part of 'objects_bloc.dart';

enum ObjectsStatus {
  initial,
  loading,
  fetched,
}

class ObjectsState extends Equatable {
  const ObjectsState._({
    required this.status,
    this.places = const [],
  });

  const ObjectsState.fetched(List<Place> places)
      : this._(status: ObjectsStatus.fetched, places: places);

  const ObjectsState.initial() : this._(status: ObjectsStatus.initial);
  const ObjectsState.loading() : this._(status: ObjectsStatus.loading);

  final ObjectsStatus status;
  final List<Place> places;

  @override
  List<Object> get props => [status, places];
}

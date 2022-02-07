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
    this.filterBy = 'name',
  });

  const ObjectsState.fetched(List<Place> places, String filterBy)
      : this._(status: ObjectsStatus.fetched, places: places, filterBy: filterBy);

  const ObjectsState.initial() : this._(status: ObjectsStatus.initial);
  const ObjectsState.loading() : this._(status: ObjectsStatus.loading);

  final ObjectsStatus status;
  final List<Place> places;
  final String filterBy;

  @override
  List<Object> get props => [status, places, filterBy];
}

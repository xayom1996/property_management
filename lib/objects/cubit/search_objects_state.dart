part of 'search_objects_cubit.dart';

abstract class SearchObjectsState extends Equatable {
  const SearchObjectsState();
}

class SearchObjectsInitial extends SearchObjectsState {
  @override
  List<Object> get props => [];
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_objects_state.dart';

class SearchObjectsCubit extends Cubit<SearchObjectsState> {
  SearchObjectsCubit() : super(SearchObjectsInitial());
}

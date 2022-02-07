import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/objects/models/place.dart';

part 'characteristics_state.dart';

class CharacteristicsCubit extends Cubit<CharacteristicsState> {
  CharacteristicsCubit() : super(const CharacteristicsState());

    void fetchObjects(List<Place> places) {
      print('A');
      emit(state.copyWith(
        places: List.from(places.map((e) => e)),
        currentIndexTab: 0,
        selectedPlaceId: 0,
        isJump: true,
      ));
    }

    void changeSelectedPlaceId(int index, {bool isJump = false}) {
      emit(state.copyWith(
        selectedPlaceId: index,
        isJump: isJump,
        currentIndexTab: 0,
      ));
    }

  void changeIndexTab(int index) {
    emit(state.copyWith(
      currentIndexTab: index,
    ));
  }
}

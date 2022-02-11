import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/objects/models/place.dart';

part 'characteristics_state.dart';

class CharacteristicsCubit extends Cubit<CharacteristicsState> {
  CharacteristicsCubit() : super(const CharacteristicsState());

    void fetchObjects(List<Place> places) {
      emit(state.copyWith(
        places: List.from(places.map((e) => e)),
        // currentIndexTab: 1,
        selectedPlaceId: state.selectedPlaceId > places.length - 1
            ? 0
            : state.selectedPlaceId,
        isJump: true,
      ));
    }

    void changeSelectedPlaceId(int? index, {bool isJump = false, String? id}) {
      if (id != null) {
        index = state.places.indexWhere((element) => element.id == id);
      }
      print(index);
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

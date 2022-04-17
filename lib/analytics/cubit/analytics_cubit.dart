import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/objects/models/place.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit() : super(const AnalyticsState());

  void changeSelectedPlaceId(int? index, List<Place> places, {bool isJump = false, String? id}) {
    if (id != null) {
      index = places.indexWhere((element) => element.id == id);
    }
    emit(state.copyWith(
      selectedPlaceId: index,
      isJump: isJump,
      // currentIndexTab: 0,
    ));
  }

  void changeIndexTab(int index) {
    emit(state.copyWith(
      currentIndexTab: index,
    ));
  }
}

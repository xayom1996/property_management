part of 'analytics_cubit.dart';

class AnalyticsState extends Equatable {
  const AnalyticsState({
    this.selectedPlaceId = 0,
    this.isJump = false,
    this.currentIndexTab = 0,
    // this.places = const [],
  });

  // final List<Place> places;
  final int selectedPlaceId;
  final bool isJump;
  final int currentIndexTab;

  @override
  List<Object> get props => [selectedPlaceId, currentIndexTab];

  AnalyticsState copyWith({
    int? selectedPlaceId,
    bool? isJump,
    int? currentIndexTab,
    // List<Place>? places,
  }) {
    return AnalyticsState(
      selectedPlaceId: selectedPlaceId ?? this.selectedPlaceId,
      isJump: isJump ?? this.isJump,
      currentIndexTab: currentIndexTab ?? this.currentIndexTab,
      // places: places ?? this.places,
    );
  }
}

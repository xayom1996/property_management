part of 'characteristics_cubit.dart';

class CharacteristicsState extends Equatable {
  const CharacteristicsState({
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

  CharacteristicsState copyWith({
    int? selectedPlaceId,
    bool? isJump,
    int? currentIndexTab,
    // List<Place>? places,
  }) {
    return CharacteristicsState(
      selectedPlaceId: selectedPlaceId ?? this.selectedPlaceId,
      isJump: isJump ?? this.isJump,
      currentIndexTab: currentIndexTab ?? this.currentIndexTab,
      // places: places ?? this.places,
    );
  }
}

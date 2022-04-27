part of 'settings_cubit.dart';

enum StateStatus {
  initial,
  loading,
  success,
  error,
}

class SettingsState extends Equatable {
  const SettingsState({
    this.selectedCharacteristic = const {},
    this.ownerName = '',
    this.characteristicsName = '',
    this.status = StateStatus.initial,
    this.errorMessage = '',
  });

  final Map selectedCharacteristic;
  final String ownerName;
  final String characteristicsName;
  final StateStatus status;
  final String errorMessage;

  @override
  List<Object> get props => [selectedCharacteristic, ownerName, characteristicsName, status];

  SettingsState copyWith({
    Map? selectedCharacteristic,
    String? ownerName,
    String? characteristicsName,
    StateStatus? status,
    String? errorMessage,
  }) {
    return SettingsState(
      selectedCharacteristic: selectedCharacteristic ?? this.selectedCharacteristic,
      ownerName: ownerName ?? this.ownerName,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      characteristicsName: characteristicsName ?? this.characteristicsName,
    );
  }
}

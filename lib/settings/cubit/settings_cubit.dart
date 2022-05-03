import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_event.dart';
import 'package:property_management/characteristics/models/characteristics.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required AppBloc appBloc})
      : _appBloc = appBloc,
        super(SettingsState()) {
        _appBlocSubscription = _appBloc.stream.listen(
                (state){

                });
  }

  final AppBloc _appBloc;
  late StreamSubscription _appBlocSubscription;

  void addNewCharacteristic(Characteristics characteristic) {

  }

  void changeCharacteristic(Map newMap) {
    emit(
        state.copyWith(
            selectedCharacteristic: newMap
        )
    );
  }

  void selectOwnerName(String value) {
    print(value);
    emit(
        state.copyWith(
            ownerName: value
        )
    );
  }

  void selectCharacteristicsName(String value) {
    emit(
        state.copyWith(
            characteristicsName: value
        )
    );
  }

  void selectCharacteristic(Characteristics? characteristic) {
    Map selectedCharacteristic = {
      'id': characteristic != null
          ? characteristic.id
          : '',
      'title': characteristic != null
          ? characteristic.title
          : '',
      'additionalInfo': characteristic != null
          ? characteristic.additionalInfo
          : '',
      'type': characteristic != null
          ? characteristic.type
          : '',
      'unit': characteristic != null
          ? characteristic.unit
          : '',
    };
    emit(
        state.copyWith(
          selectedCharacteristic: selectedCharacteristic,
          status: StateStatus.initial
        )
    );
  }

  void saveCharacteristic(String action) async {
    emit(
        state.copyWith(
            status: StateStatus.loading
        )
    );
    Map selectedCharacteristic = state.selectedCharacteristic;
    String ownerName = state.ownerName;
    String characteristicsName = state.characteristicsName;

    if (selectedCharacteristic['title'].isEmpty
        || selectedCharacteristic['type'].isEmpty){
      emit(
          state.copyWith(
              status: StateStatus.error
          )
      );
    } else {
      Map<String, dynamic> owners = _appBloc.state.owners;
      List<Characteristics> characteristics = owners[ownerName][characteristicsName];
      int lastId = characteristics.last.id;
      Characteristics characteristic;
      if (action == 'add') {
        characteristic = Characteristics(
          id: lastId + 1,
          title: selectedCharacteristic['title'],
          type: selectedCharacteristic['type'],
          placeholder: 'Введите ${selectedCharacteristic['title'].toString().toLowerCase()}',
          additionalInfo: selectedCharacteristic['additionalInfo'],
          unit: selectedCharacteristic['type'] == 'Число'
              ? selectedCharacteristic['unit']
              : '',
          isDefault: false,
        );
        characteristics.add(characteristic);
      } else {
        int index = characteristics.lastIndexWhere((element) => element.id == selectedCharacteristic['id']);
        characteristic = characteristics[index];
        if (characteristic.title == selectedCharacteristic['title']
            && characteristic.additionalInfo == selectedCharacteristic['additionalInfo']
            && characteristic.unit == selectedCharacteristic['unit']) {
          emit(
              state.copyWith(
                  status: StateStatus.success
              )
          );
          return;
        }
        characteristic.title = selectedCharacteristic['title'];
        characteristic.additionalInfo = selectedCharacteristic['additionalInfo'];
        characteristic.unit = selectedCharacteristic['type'] == 'Число'
            ? selectedCharacteristic['unit']
            : '';
      }

      int count = characteristics.where((element) => element.title == characteristic.title).length;
      if ((action == 'add' && count == 1) || count > 1)  {
        emit(
            state.copyWith(
              status: StateStatus.error,
              errorMessage: 'Характеристика с таким названием уже существует',
            )
        );
        return;
      }

      await _appBloc.fireStoreService.saveCharacteristic(
          characteristics: characteristics,
          ownerName: ownerName, characteristicsName: characteristicsName);
      owners[ownerName][characteristicsName] = characteristics;
      _appBloc.add(AppOwnerUpdated(owners));
      emit(
          state.copyWith(
              status: StateStatus.success
          )
      );

      try {

      } catch (e) {
        print(e);
      }
      print(characteristic);
    }
  }

  void deleteCharacteristic(int index) async {
    emit(
        state.copyWith(
            status: StateStatus.loading
        )
    );
    String ownerName = state.ownerName;
    String characteristicsName = state.characteristicsName;

    Map<String, dynamic> owners = _appBloc.state.owners;
    List<Characteristics> characteristics = owners[ownerName][characteristicsName];
    characteristics.removeAt(index);

    try {
      await _appBloc.fireStoreService.saveCharacteristic(
          characteristics: characteristics,
          ownerName: ownerName, characteristicsName: characteristicsName);
      owners[ownerName][characteristicsName] = characteristics;
      _appBloc.add(AppOwnerUpdated(owners));
      emit(
          state.copyWith(
              status: StateStatus.success
          )
      );
    } catch (e) {
      print(e);
      emit(
          state.copyWith(
              status: StateStatus.error
          )
      );
    }
  }

  void visibilityCharacteristic(int index, {required bool isVisible}) async {
    emit(
        state.copyWith(
            status: StateStatus.loading
        )
    );
    String ownerName = state.ownerName;
    String characteristicsName = state.characteristicsName;
    Map<String, dynamic> owners = _appBloc.state.owners;

    List<Characteristics> characteristics = owners[ownerName][characteristicsName];
    characteristics[index].visible = isVisible;

    try {
      await _appBloc.fireStoreService.saveCharacteristic(
          characteristics: characteristics,
          ownerName: ownerName, characteristicsName: characteristicsName);
      owners[ownerName][characteristicsName] = characteristics;
      _appBloc.add(AppOwnerUpdated(owners));
      emit(
          state.copyWith(
              status: StateStatus.success
          )
      );
    } catch (e) {
      print(e);
      emit(
          state.copyWith(
              status: StateStatus.error
          )
      );
    }
  }
}

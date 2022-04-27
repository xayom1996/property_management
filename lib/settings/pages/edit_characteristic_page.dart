import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_management/characteristics/models/characteristics.dart';
import 'package:property_management/settings/pages/change_field_page.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/input_field.dart';
import 'package:property_management/settings/cubit/settings_cubit.dart';

class EditCharacteristicPage extends StatefulWidget {
  final String title;
  final Characteristics item;
  const EditCharacteristicPage({Key? key, required this.title, required this.item}) : super(key: key);

  @override
  State<EditCharacteristicPage> createState() => _EditCharacteristicPageState();
}

class _EditCharacteristicPageState extends State<EditCharacteristicPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController additionalController = TextEditingController();

  @override
  void initState() {
    titleController.text = context.read<SettingsCubit>().state.selectedCharacteristic['title'] ?? '';
    additionalController.text = context.read<SettingsCubit>().state.selectedCharacteristic['additionalInfo'] ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state.status == StateStatus.success) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            centerTitle: true,
            leading: null,
            automaticallyImplyLeading: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoxIcon(
                  iconPath: 'assets/icons/back.svg',
                  iconColor: Colors.black,
                  backgroundColor: Colors.white,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      state.selectedCharacteristic['title'],
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: body,
                    ),
                  ),
                ),
                BoxIcon(
                  iconPath: 'assets/icons/check.svg',
                  iconColor: Colors.black,
                  backgroundColor: Colors.white,
                  onTap: () {
                    context.read<SettingsCubit>().saveCharacteristic('edit');
                    // Navigator.pop(context);
                  },
                ),
              ],
            ),
            elevation: 0,
            toolbarHeight: 68,
            backgroundColor: kBackgroundColor,
          ),
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44), vertical: 16),
                  child: Column(
                    children: [
                      BoxInputField(
                        controller: titleController,
                        placeholder: 'Введите название характеристике',
                        title: 'Название характеристики',
                        enabled: true,
                        trailing: null,
                        onChanged: (String value) {
                          Map newMap = {...state.selectedCharacteristic};
                          newMap['title'] = value;
                          context.read<SettingsCubit>().changeCharacteristic(newMap);
                        },
                        isError: state.status == StateStatus.error
                            && state.selectedCharacteristic['title'].isEmpty,
                        errorText: 'Это поле не может быть пустым',
                      ),
                      BoxInputField(
                        controller: additionalController,
                        placeholder: 'Введите дополнительную информацию',
                        title: 'Дополнительная информация',
                        enabled: true,
                        trailing: null,
                        onChanged: (String value) {
                          Map newMap = {...state.selectedCharacteristic};
                          newMap['additionalInfo'] = value;
                          context.read<SettingsCubit>().changeCharacteristic(newMap);
                        },
                        // isError: isError,
                      ),
                      BoxInputField(
                        controller: TextEditingController(text: state.selectedCharacteristic['type']),
                        placeholder: 'Выберите тип характеристики',
                        title: 'Тип характеристики',
                        enabled: false,
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Color(0xff5589F1),
                        ),
                        isError: state.status == StateStatus.error
                            && state.selectedCharacteristic['type'].isEmpty,
                        errorText: 'Это поле не может быть пустым',
                      ),
                      if (state.selectedCharacteristic['type'] == 'Число')
                        BoxInputField(
                          controller: TextEditingController(text: state.selectedCharacteristic['unit']),
                          placeholder: 'Выберите единицы измерения',
                          title: 'Единицы измерения',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChangeFieldPage(
                                title: 'Единицы измерения',
                                onSave: (String value) {
                                  Map newMap = {...state.selectedCharacteristic};
                                  newMap['unit'] = '';
                                  if (value.contains(' - ')) {
                                    newMap['unit'] = value.split(' - ').last;
                                  }
                                  context.read<SettingsCubit>().changeCharacteristic(newMap);
                                },
                                selectItem: state.selectedCharacteristic['unit'].contains(' - ')
                                    ? state.selectedCharacteristic['unit']
                                    : 'Без единицы измерения',
                                items: const ['Рубли - ₽', 'Метры квадратные - Кв.м', 'Процент - %', 'Штука - шт.', 'Киловатт - кВт', 'Без единицы измерения'],
                              )),
                            );
                          },
                          isError: state.status == StateStatus.error
                              && state.selectedCharacteristic['unit'].isEmpty,
                          errorText: 'Это поле не может быть пустым',
                          enabled: false,
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Color(0xff5589F1),
                          ),
                          // isError: isError,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
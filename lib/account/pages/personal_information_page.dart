import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_management/account/cubit/personal_info/personal_info_cubit.dart';
import 'package:property_management/account/pages/successfull_page.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_event.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/custom_alert_dialog.dart';
import 'package:property_management/app/widgets/input_field.dart';

class PersonalInformationPage extends StatefulWidget {
  PersonalInformationPage({Key? key}) : super(key: key);

  @override
  State<PersonalInformationPage> createState() => _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  TextEditingController _secondName = TextEditingController();

  TextEditingController _firstName = TextEditingController();

  TextEditingController _patronymic = TextEditingController();

  TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.read<AppBloc>().state.user;

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
            Spacer(),
            Text('Личная информация',
              style: body,
            ),
            Spacer(),
            BoxIcon(
              iconPath: 'assets/icons/check.svg',
              iconColor: Colors.black,
              backgroundColor: Colors.white,
              onTap: () {
                if (_firstName.text.replaceAll(' ', '').isEmpty
                    || _secondName.text.replaceAll(' ', '').isEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) => const CustomAlertDialog(
                        title: 'Имя и Фамилия должны быть заполнены',
                        firstButtonTitle: 'Ок',
                        secondButtonTitle: null,
                      )
                  );
                  return;
                }
                if (user.firstName != _firstName.text ||
                    user.secondName != _secondName.text || user.patronymic != _patronymic.text){
                  context.read<AppBloc>().add(
                      AppUserUpdated(
                          user.copyWith(
                            firstName: _firstName.text,
                            secondName: _secondName.text,
                            patronymic: _patronymic.text,
                          )
                      )
                  );
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        SuccessfullPage(
                          information: Text(
                            'Личная информация успешно изменена',
                            textAlign: TextAlign.center,
                            style: body.copyWith(
                                color: Color(0xff151515)
                            ),
                          ),
                        )),
                  );
                }
                else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        elevation: 0,
        toolbarHeight: 68,
        backgroundColor: kBackgroundColor,
      ),
      body: BlocConsumer<PersonalInfoCubit, PersonalInfoState>(
        listener: (context, state) {
        },
        builder: (context, state) {
          if (_email.text.isEmpty) {
            _email.text = user.email;
            _firstName.text = user.firstName ?? '';
            _firstName.selection = TextSelection.fromPosition(
                TextPosition(offset: _firstName.text.length));
            _secondName.text = user.secondName ?? '';
            _secondName.selection = TextSelection.fromPosition(
                TextPosition(offset: _secondName.text.length));
            _patronymic.text = user.patronymic ?? '';
            _patronymic.selection = TextSelection.fromPosition(
                TextPosition(offset: _patronymic.text.length));
          }

          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding(context, 44), vertical: 16),
                  child: Column(
                    children: [
                      BoxInputField(
                        controller: _secondName,
                        onChanged: (String value) {},
                        disableSpace: true,
                        placeholder: 'Введите фамилию',
                        title: 'Фамилия',
                      ),
                      BoxInputField(
                        controller: _firstName,
                        placeholder: 'Введите имя',
                        disableSpace: true,
                        title: 'Имя',
                      ),
                      BoxInputField(
                        controller: _patronymic,
                        placeholder: 'Введите отчество',
                        disableSpace: true,
                        title: 'Отчество',
                      ),
                      BoxInputField(
                        controller: _email,
                        placeholder: 'Введите почту',
                        title: 'E-mail',
                        enabled: false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
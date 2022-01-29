import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_management/account/cubit/personal_info/personal_info_cubit.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_event.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/input_field.dart';

class PersonalInformationPage extends StatelessWidget {
  PersonalInformationPage({Key? key}) : super(key: key);

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
          _email.text = user.email;
          _firstName.text = user.firstName ?? '';
          _secondName.text = user.secondName ?? '';
          _patronymic.text = user.patronymic ?? '';

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
                        onChanged: (String value) {
                        },
                        placeholder: 'Введите фамилию',
                        title: 'Фамилия',
                      ),
                      BoxInputField(
                        controller: _firstName,
                        placeholder: 'Введите имя',
                        title: 'Имя',
                      ),
                      BoxInputField(
                        controller: _patronymic,
                        placeholder: 'Введите отчество',
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
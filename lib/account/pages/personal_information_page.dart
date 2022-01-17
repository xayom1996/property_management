import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/utils/utils.dart';
import 'package:property_management/widgets/box_icon.dart';
import 'package:property_management/widgets/input_field.dart';

class PersonalInformationPage extends StatelessWidget {
  const PersonalInformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                Navigator.pop(context);
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
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding(44), vertical: 16),
                child: Column(
                  children: [
                    BoxInputField(
                      controller: TextEditingController(),
                      placeholder: 'Введите фамилию',
                      title: 'Фамилия',
                    ),
                    BoxInputField(
                      controller: TextEditingController(),
                      placeholder: 'Введите имя',
                      title: 'Имя',
                    ),
                    BoxInputField(
                      controller: TextEditingController(),
                      placeholder: 'Введите отчество',
                      title: 'Отчество',
                    ),
                    BoxInputField(
                      controller: TextEditingController(text: 'kvitko@mail.ru'),
                      placeholder: 'Введите почту',
                      title: 'E-mail',
                    ),
                  ],
                ),
              ),
            ),
          ],
      ),
    );
  }

}
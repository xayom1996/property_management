import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/utils/utils.dart';
import 'package:property_management/widgets/box_icon.dart';
import 'package:property_management/widgets/container_for_transition.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

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
            Text('Личный кабинет',
              style: body,
            ),
            Spacer(),
            BoxIcon(
              iconPath: 'assets/icons/chat.svg',
              iconColor: Colors.black,
              backgroundColor: Colors.white,
            ),
          ],
        ),
        elevation: 0,
        toolbarHeight: 68,
        backgroundColor: kBackgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding(44), vertical: 16),
        child: Column(
          children: [
            ContainerForTransition(
              title: 'Личная информация',
              onTap: () {  },
            ),
            ContainerForTransition(
              title: 'Изменить пароль',
              onTap: () {  },
            ),
          ],
        ),
      ),
    );
  }

}
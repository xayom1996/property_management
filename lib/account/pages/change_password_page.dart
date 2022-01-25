import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/account/pages/successfull_page.dart';
import 'package:property_management/theme/colors.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/utils/user_repository.dart';
import 'package:property_management/utils/utils.dart';
import 'package:property_management/widgets/box_button.dart';
import 'package:property_management/widgets/box_icon.dart';
import 'package:property_management/widgets/input_field.dart';
import 'package:provider/src/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  String currentPassword = '';
  String newPassword = '';

  @override
  void initState() {
    currentPasswordController.addListener(() {
      setState(() {
        currentPassword = currentPasswordController.text;
      });
    });

    newPasswordController.addListener(() {
      setState(() {
        newPassword = newPasswordController.text;
      });
    });
    super.initState();
  }

  bool isDisabledButton() {
    return currentPassword != '' && newPassword != '';
  }

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
            Text('Изменить пароль',
              style: body,
            ),
            Spacer(),
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
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44), vertical: 16),
                  child: Column(
                    children: [
                      BoxInputField(
                        controller: currentPasswordController,
                        placeholder: 'Введите текущий пароль',
                        title: 'Текущий пароль',
                        password: true,
                      ),
                      BoxInputField(
                        controller: newPasswordController,
                        placeholder: 'Введите новый пароль',
                        title: 'Новый пароль',
                        password: true,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 0.24.sw),),
                  child: BoxButton(
                    title: 'Изменить пароль',
                    disabled: isDisabledButton() ? false : true,
                    onTap: () {
                      context.read<UserRepository>().changePassword(currentPassword, newPassword);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SuccessfullPage(
                          information: Text(
                            'Ваш пароль успешно изменен',
                            textAlign: TextAlign.center,
                            style: body.copyWith(
                                color: Color(0xff151515)
                            ),
                          ),
                        )),
                      );
                    },
                    // busy: isBusy,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
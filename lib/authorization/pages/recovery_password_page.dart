import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/theme/box_ui.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/utils/utils.dart';

class RecoveryPasswordPage extends StatefulWidget {
  RecoveryPasswordPage({Key? key}) : super(key: key);

  @override
  State<RecoveryPasswordPage> createState() => _RecoveryPasswordPageState();
}

class _RecoveryPasswordPageState extends State<RecoveryPasswordPage> {
  bool isError = false;
  bool isBusy = false;
  bool isSuccess = false;
  final TextEditingController emailController = TextEditingController();

  String email = '';
  String emailErrorText = '';

  bool isDisabledButton() {
    return emailController.text != '';
  }

  @override
  void initState() {
    emailController.addListener(() {
      setState(() {
        email = emailController.text;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(252, 252, 252, 1),
        body: !isSuccess
            ? Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 44,
                              horizontal: horizontalPadding(0.24.sw),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Spacer(),
                              BoxText.headingTwo('Восстановление пароля'),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                'Для восстановления пароля введите свой почтовый адрес, указанный при регистрации',
                                textAlign: TextAlign.center,
                                style: body.copyWith(
                                    color: Color(0xffA3A7AE)
                                ),
                              ),
                              SizedBox(
                                height: 54,
                              ),
                              BoxInputField(
                                controller: emailController,
                                placeholder: 'Введите почтовый адрес',
                                title: 'Почтовый адрес',
                                isError: isError,
                                errorText: emailErrorText,
                              ),
                              Spacer(),
                              BoxButton(
                                title: 'Восстановить',
                                disabled: isDisabledButton() ? false : true,
                                onTap: () {
                                  setState(() {
                                    if (validateEmail(email).isNotEmpty) {
                                      isError = true;
                                      emailErrorText = 'Введите корректный почтовый адрес';
                                    }
                                    else{
                                      isError = false;
                                      isBusy = true;
                                      isSuccess = true;
                                      emailErrorText = '';
                                    }
                                  });
                                },
                                busy: isBusy,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!isSuccess)
                    Positioned(
                      child: Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      top: 16,
                      left: 16,
                    ),
                ],
              )
            : CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 44,
                        horizontal: horizontalPadding(0.24.sw),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(),
                          SvgPicture.asset(
                            'assets/icons/success_rounded.svg',
                            height: 68,
                          ),
                          SizedBox(
                            height: 64,
                          ),
                          Text(
                            'Успешно!',
                            style: title2,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Для восстановления пароля введите свой почтовый адрес, указанный при регистрации',
                            textAlign: TextAlign.center,
                            style: body.copyWith(
                                color: Color(0xff151515)
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Text(
                            emailController.text,
                            style: body.copyWith(
                              color: Color(0xff151515),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Spacer(),
                          BoxButton(
                            title: 'Понятно',
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
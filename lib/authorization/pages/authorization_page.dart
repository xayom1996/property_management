import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/authorization/pages/recovery_password_page.dart';
import 'package:property_management/dashboard/dashboard_page.dart';
import 'package:property_management/theme/box_ui.dart';
import 'package:property_management/theme/styles.dart';
import 'package:property_management/utils/utils.dart';

class AuthorizationPage extends StatefulWidget {
  AuthorizationPage({Key? key}) : super(key: key);

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String login = '';
  String password = '';
  String loginErrorText = '';
  bool isBusy = false;
  bool isError = false;
  bool isPassword = true;

  @override
  void initState() {
    loginController.addListener(() {
      setState(() {
        login = loginController.text;
      });
      if (login.contains(' ')) {
        loginController.text = login.replaceAll(' ', '');
        loginController.selection = TextSelection.fromPosition(
            TextPosition(offset: loginController.text.length));
      }
    });

    passwordController.addListener(() {
      setState(() {
        password = passwordController.text;
      });
    });

    super.initState();
  }

  bool isDisabledButton() {
    return login != '' && password != '';
  }

  void logIn() {
    Navigator.pop(context);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => DashboardPage(),
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: horizontalPadding(context, 0.24.sw),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/logos/logo.svg',
                        ),
                        Spacer(),
                        BoxText.headingTwo('???????? ?? ??????????????'),
                        SizedBox(
                          height: 24,
                        ),
                        BoxInputField(
                          controller: loginController,
                          placeholder: '?????????????? ??????????',
                          title: '??????????',
                          errorText: loginErrorText,
                          isError: isError,
                        ),
                        BoxInputField(
                          controller: passwordController,
                          placeholder: '?????????????? ????????????',
                          title: '????????????',
                          password: isPassword,
                          isError: isError,
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Text(
                            isError && loginErrorText == ''
                              ? '???????????????? ?????????? ?? ????????????'
                              : '',
                          style: body.copyWith(
                            color: const Color.fromRGBO(255, 77, 109, 1)
                          )
                        ),
                        Spacer(),
                        GestureDetector(
                          onDoubleTap: () { /// ?????????????? ?????????????? ?????????? ??????????. ???????? ?????????? ?????????????? ?????? ??????????????
                            logIn();
                          },
                          child: BoxButton(
                            title: '??????????',
                            disabled: isDisabledButton() ? false : true,
                            onTap: () {
                              setState(() {
                                if (login == 'admin@admin.com' && password == '123456'){
                                  isError = false;
                                  isBusy = true;
                                  logIn();
                                } else {
                                  if (validateEmail(login).isNotEmpty){
                                    loginErrorText = '?????????????? ???????????????????? ???????????????? ??????????';
                                  }
                                  else {
                                    loginErrorText = '';
                                  }
                                  isError = true;
                                }
                              });
                            },
                            busy: isBusy,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RecoveryPasswordPage()),
                            );
                          },
                          child: Text(
                              '???????????? ?????????????',
                              style: body.copyWith(
                                  color: Color.fromRGBO(21, 21, 21, 1)
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
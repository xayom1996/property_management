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
    return SafeArea(
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
                      horizontal: horizontalPadding(0.24.sw),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/logos/logo.svg',
                      ),
                      Spacer(),
                      BoxText.headingTwo('Вход в систему'),
                      SizedBox(
                        height: 24,
                      ),
                      BoxInputField(
                        controller: loginController,
                        placeholder: 'Введите логин',
                        title: 'Логин',
                        errorText: loginErrorText,
                        isError: isError,
                      ),
                      BoxInputField(
                        controller: passwordController,
                        placeholder: 'Введите пароль',
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPassword = !isPassword;
                            });
                          },
                          child: Icon(
                              isPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Color(0xffA3A7AE),
                          ),
                        ),
                        title: 'Пароль',
                        password: isPassword,
                        isError: isError,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Text(
                          isError && loginErrorText == ''
                            ? 'Неверный логин и пароль'
                            : '',
                        style: body.copyWith(
                          color: const Color.fromRGBO(255, 77, 109, 1)
                        )
                      ),
                      Spacer(),
                      BoxButton(
                        title: 'Войти',
                        disabled: isDisabledButton() ? false : true,
                        onTap: () {
                          setState(() {
                            if (login == 'admin@admin.com' && password == '123456'){
                              isError = false;
                              isBusy = true;
                              logIn();
                            } else {
                              if (validateEmail(login).isNotEmpty){
                                loginErrorText = 'Введите корректный почтовый адрес';
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
                            'Забыли пароль?',
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
    );
  }
}
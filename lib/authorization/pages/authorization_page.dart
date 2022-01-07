import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/authorization/pages/recovery_password_page.dart';
import 'package:property_management/dashboard/dashboard_page.dart';
import 'package:property_management/theme/box_ui.dart';
import 'package:property_management/theme/styles.dart';

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
        // resizeToAvoidBottomInset: false,
        body: Container(
          // height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).viewInsets.bottom == 0
                  ? 44.h
                  : 10.h,
                horizontal: 24.w
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/logos/logo.svg',
                ),
                Spacer(),
                // SizedBox(
                //   height: 160.h,
                // ),
                BoxText.headingTwo('Вход в систему'),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom == 0
                      ? 24.h
                      : 0,
                ),
                BoxInputField(
                  controller: loginController,
                  placeholder: 'Введите логин',
                  title: 'Логин',
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
                  height: MediaQuery.of(context).viewInsets.bottom == 0
                      ? 32.h
                      : 0,
                ),
                Text(
                    isError
                      ? 'Неверный логин и пароль'
                      : '',
                  style: body.copyWith(
                    color: const Color.fromRGBO(255, 77, 109, 1)
                  )
                ),
                Spacer(flex: 2,),
                // SizedBox(
                //   height: 112.h,
                // ),
                BoxButton(
                  title: 'Войти',
                  disabled: isDisabledButton() ? false : true,
                  onTap: () {
                    setState(() {
                      if (login == 'admin' && password == '123456'){
                        isError = false;
                        isBusy = true;
                        logIn();
                      } else {
                        isError = true;
                      }
                    });
                  },
                  busy: isBusy,
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom == 0
                      ? 40.h
                      : 0,
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
    );
  }
}
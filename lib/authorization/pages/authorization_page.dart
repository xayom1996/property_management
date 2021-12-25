import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/authorization/pages/recovery_password_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(252, 252, 252, 1),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/logos/logo.svg',
                // height: 22,
              ),
              Spacer(),
              BoxText.headingTwo('Вход в систему'),
              SizedBox(
                height: 24.h,
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
                height: 32.h,
              ),
              Text(
                  isError
                    ? 'Неверный логин и пароль'
                    : '',
                style: body.copyWith(
                  color: const Color.fromRGBO(255, 77, 109, 1)
                )
              ),
              Spacer(),
              // Spacer(),
              BoxButton(
                title: 'Войти',
                disabled: isDisabledButton() ? false : true,
                onTap: () {
                  setState(() {
                    if (login == 'admin' && password == '123456'){
                      isError = false;
                      isBusy = true;
                    } else {
                      isError = true;
                    }
                  });
                },
                busy: isBusy,
              ),
              const SizedBox(
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
    );
  }
}
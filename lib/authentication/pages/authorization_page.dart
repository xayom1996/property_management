import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/authentication/cubit/auth/auth_cubit.dart';
import 'package:property_management/authentication/pages/recovery_password_page.dart';
import 'package:property_management/dashboard/dashboard_page.dart';
import 'package:property_management/app/theme/box_ui.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/services/user_repository.dart';
import 'package:property_management/app/utils/utils.dart';

class AuthorizationPage extends StatelessWidget {
  final bool? addNewAccount;
  AuthorizationPage({Key? key, this.addNewAccount = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          body: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.status.isSubmissionSuccess) {
                Navigator.pop(context);
                if (addNewAccount != true)
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => DashboardPage(),
                      transitionDuration: Duration.zero,
                    ),
                  );
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  CustomScrollView(
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
                                      BoxText.headingTwo('Вход в систему'),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      BoxInputField(
                                        key: const Key('loginForm_emailInput_textField'),
                                        onChanged: (email) => context.read<AuthCubit>().emailChanged(email),
                                        placeholder: 'Введите логин',
                                        title: 'Логин',
                                        errorText: !state.email.valid ? 'Введите корректный почтовый адрес': '',
                                        isError: state.email.value.length > 3 && !state.email.valid || state.status.isSubmissionFailure,
                                      ),
                                      BoxInputField(
                                        key: const Key('loginForm_passwordInput_textField'),
                                        onChanged: (password) => context.read<AuthCubit>().passwordChanged(password),
                                        placeholder: 'Введите пароль',
                                        title: 'Пароль',
                                        password: true,
                                        // password: isPassword,
                                        isError: state.status.isSubmissionFailure,
                                      ),
                                      SizedBox(
                                        height: 32,
                                      ),
                                      Text(
                                          state.status.isSubmissionFailure
                                              ? state.errorMessage ?? ''
                                              : '',
                                          style: body.copyWith(
                                              color: const Color.fromRGBO(255, 77, 109, 1)
                                          )
                                      ),
                                      Spacer(),
                                      BoxButton(
                                        title: 'Войти',
                                        disabled: !state.status.isValidated,
                                        onTap: () => context.read<AuthCubit>().logIn(),
                                        busy: state.status.isSubmissionInProgress,
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
                  if (addNewAccount == true)
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
                      top: 24,
                      left: 16,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:property_management/account/pages/successfull_page.dart';
import 'package:property_management/app/theme/box_ui.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/services/user_repository.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/authentication/cubit/recovery_password/recovery_password_cubit.dart';
import 'package:provider/src/provider.dart';

class RecoveryPasswordPage extends StatelessWidget {
  RecoveryPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          body: BlocConsumer<RecoveryPasswordCubit, RecoveryPasswordState>(
            listener: (context, state) {
              if (state.status.isSubmissionSuccess) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      SuccessfullPage(
                          information: Column(
                            children: [
                              Text(
                                'На ваш почтовый адрес выслана инструкция для смены пароля',
                                textAlign: TextAlign.center,
                                style: body.copyWith(
                                    color: Color(0xff151515)
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                state.email.value,
                                style: body.copyWith(
                                  color: Color(0xff151515),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                      )),
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
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 44,
                                  horizontal: horizontalPadding(context, 0.24.sw),
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
                                      key: const Key('recovery_emailInput_textField'),
                                      onChanged: (email) => context.read<RecoveryPasswordCubit>().emailChanged(email),
                                      placeholder: 'Введите почтовый адрес',
                                      title: 'Почтовый адрес',
                                      disableSpace: true,
                                      errorText: state.errorMessage != 'Неверный логин и пароль'
                                          ? state.errorMessage
                                          : '',
                                      isError: state.status.isSubmissionFailure,
                                    ),
                                    Spacer(),
                                    BoxButton(
                                      title: 'Восстановить',
                                      disabled: !state.status.isValidated,
                                      onTap: () => context.read<RecoveryPasswordCubit>().resetPassword(),
                                      busy: state.status.isSubmissionInProgress,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
                    );
            },
          ),
        ),
      ),
    );
  }
}
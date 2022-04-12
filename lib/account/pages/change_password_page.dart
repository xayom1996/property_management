import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:property_management/account/cubit/change_password/change_password_cubit.dart';
import 'package:property_management/account/pages/successfull_page.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_button.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/input_field.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

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
                context.read<ChangePasswordCubit>().initialState();
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
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  SuccessfullPage(
                    information: Text(
                      'Ваш пароль успешно изменен',
                      textAlign: TextAlign.center,
                      style: body.copyWith(
                          color: Color(0xff151515)
                      ),
                    ),
                  )),
            );
          }
        },
        builder: (context, state) {
          return CustomScrollView(
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
                              key: const Key('currentPassword_textField'),
                              onChanged: (password) => context.read<ChangePasswordCubit>().currentPasswordChanged(password),
                              placeholder: 'Введите текущий пароль',
                              title: 'Текущий пароль',
                              password: true,
                              errorText: state.errorMessage == 'Неверный текущий пароль' ? state.errorMessage : '',
                              isError: state.errorMessage == 'Неверный текущий пароль' ? true : false,
                            ),
                            BoxInputField(
                              key: const Key('newPassword_textField'),
                              onChanged: (password) => context.read<ChangePasswordCubit>().newPasswordChanged(password),
                              placeholder: 'Введите новый пароль',
                              title: 'Новый пароль',
                              password: true,
                              errorText: state.errorMessage == 'Пароль должен быть минимум 6 символов' ? state.errorMessage : '',
                              isError: state.errorMessage == 'Пароль должен быть минимум 6 символов' ? true : false,
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 0.24.sw),),
                        child: BoxButton(
                          title: 'Изменить пароль',
                          disabled: !state.status.isValidated,
                          onTap: () => context.read<ChangePasswordCubit>().changePassword(),
                          busy: state.status.isSubmissionInProgress,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ],
            );
        },
      ),
    );
  }
}
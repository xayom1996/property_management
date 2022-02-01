import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/account/cubit/change_password/change_password_cubit.dart';
import 'package:property_management/account/cubit/personal_info/personal_info_cubit.dart';
import 'package:property_management/account/pages/change_password_page.dart';
import 'package:property_management/account/pages/personal_information_page.dart';
import 'package:property_management/account/widgets/change_profile_bottom_sheet.dart';
import 'package:property_management/account/widgets/logout_alert_dialog.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/services/user_repository.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/container_for_transition.dart';
import 'package:provider/src/provider.dart';

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
              onTap: () {

              },
            ),
          ],
        ),
        elevation: 0,
        toolbarHeight: 68,
        backgroundColor: kBackgroundColor,
      ),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44), vertical: 16),
                    child: Column(
                      children: [
                        Text(
                          state.user.getFullName(),
                          textAlign: TextAlign.center,
                          style: title2.copyWith(
                            color: Color(0xffC7C9CC),
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        ContainerForTransition(
                          title: 'Личная информация',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PersonalInformationPage()),
                            );
                          },
                        ),
                        ContainerForTransition(
                          title: 'Изменить пароль',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                            );
                          },
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent, isScrollControlled: true,
                                builder: (context) {
                                  return ChangeProfileBottomSheet();
                                }
                            );
                          },
                          child: Text(
                            'Сменить аккаунт',
                            textAlign: TextAlign.center,
                            style: body,
                          ),
                        ),
                        SizedBox(
                          height: 49,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => LogoutAlertDialog()
                            );
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/logout.svg',
                                  color: Color(0xff5589F1),
                                  height: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Выйти',
                                  textAlign: TextAlign.center,
                                  style: body.copyWith(
                                      color: Color(0xff5589F1)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
        },
      ),
    );
  }

}
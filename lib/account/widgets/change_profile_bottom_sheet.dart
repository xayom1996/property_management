import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/app/theme/box_ui.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/custom_alert_dialog.dart';
import 'package:property_management/authentication/cubit/auth/auth_cubit.dart';
import 'package:property_management/authentication/pages/authorization_page.dart';
import 'package:provider/src/provider.dart';

class ChangeProfileBottomSheet extends StatefulWidget {
  const ChangeProfileBottomSheet({Key? key}) : super(key: key);

  @override
  State<ChangeProfileBottomSheet> createState() => _ChangeProfileBottomSheetState();
}

class _ChangeProfileBottomSheetState extends State<ChangeProfileBottomSheet> {
  Map accounts = {};
  Map account = {};
  final dataKey = new GlobalKey();

  @override
  void initState() {
    getAccounts();
    super.initState();
  }

  void getAccounts() async{
    var box = await Hive.openBox('accountsBox');
    account = box.get('account') ?? {};
    if (box.get('accounts') != null) {
      accounts = box.get('accounts');
    }
    accounts[account['email']] = account;
    setState(() {});
  }

  void deleteAccount(String email) async {
    var box = await Hive.openBox('accountsBox');
    accounts.remove(email);
    box.put('accounts', accounts);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44, portraitPadding: 0)),
          child: Container(
            // height: 335,
            constraints: BoxConstraints(
              maxHeight: min(MediaQuery.of(context).size.height - 60, (245 + 40 * 3).toDouble()),
              // maxHeight: (600).toDouble(),
            ),
            decoration: BoxDecoration(
              color: kBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(22)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Container(
                      height: 6,
                      width: 36,
                      decoration: BoxDecoration(
                        color: Color(0xffE9ECEE),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Сменить аккаунт',
                        style: body.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 26,
                      ),
                      Container(
                        height: min(MediaQuery.of(context).size.height - 60, (245 + 40 * 3).toDouble()) / 3,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: [
                            for (var account in accounts.values)
                              Column(
                                children: [
                                  Slidable(
                                    key: ValueKey(account['email']),
                                    endActionPane: ActionPane(
                                      motion: ScrollMotion(),
                                      children: [
                                        Spacer(),
                                        BoxIcon(
                                          iconPath: 'assets/icons/trash.svg',
                                          iconColor: Colors.black,
                                          backgroundColor: Colors.white,
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) => CustomAlertDialog(
                                                    title: 'Удалить аккаунт из списка быстрого доступа?',
                                                    onApprove: () {
                                                      deleteAccount(account['email']);
                                                    }
                                                )
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                    enabled: state.user.email != account['email'],
                                    child: InkWell(
                                      onTap: () {
                                        if (state.user.email != account['email']) {
                                          context.read<AuthCubit>().logIn(
                                            email: account['email'],
                                            password: account['password'],
                                          );
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              account['fullName'] ?? account['email'],
                                              style: body,
                                            ),
                                            if (state.user.email == account['email'])
                                              Icon(
                                                Icons.check,
                                                size: 22,
                                                color: Color(0xff5589F1),
                                              )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (accounts.values.last != account)
                                    Divider()
                                ],
                              ),
                          ],
                        ),
                      ),
                      // Column(
                      //   children: [
                      //     for (var account in accounts.values)
                      //       Column(
                      //         children: [
                      //           InkWell(
                      //             onTap: () {
                      //               if (state.user.email != account['email']) {
                      //                 // context.read<AuthCubit>().logIn(
                      //                 //   email: account['email'],
                      //                 //   password: account['password'],
                      //                 // );
                      //                 Navigator.pop(context);
                      //               }
                      //             },
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(12.0),
                      //               child: Row(
                      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                 children: [
                      //                   Text(
                      //                     account['fullName'] ?? account['email'],
                      //                     style: body,
                      //                   ),
                      //                   if (state.user.email == account['email'])
                      //                     Icon(
                      //                       Icons.check,
                      //                       size: 22,
                      //                       color: Color(0xff5589F1),
                      //                     )
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //           if (accounts.values.last != account)
                      //             Divider()
                      //         ],
                      //       ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ),
                // if (accounts.values.length < 3)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 0.25.sw)),
                    child: SizedBox(
                      width: 1.sw - horizontalPadding(context, 0.25.sw) * 2,
                      child: BoxButton(
                        title: 'Добавить новый аккаунт',
                        onTap: (){
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AuthorizationPage(addNewAccount: true,)),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            )
          ),
        );
      },
    );
  }
}
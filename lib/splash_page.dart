import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/authentication/pages/authorization_page.dart';
import 'package:property_management/dashboard/dashboard_page.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/objects/bloc/objects_bloc.dart';

class SplashPage extends StatefulWidget{
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  // @override
  // void initState() {
  //   super.initState();
  //   setTimer();
  // }
  //
  // void setTimer(){
  //   Timer(const Duration(milliseconds: 1500), () {
  //     Navigator.pop(context);
  //     Navigator.push(
  //       context,
  //       PageRouteBuilder(
  //         pageBuilder: (context, animation1, animation2) => AuthorizationPage(),
  //         transitionDuration: Duration.zero,
  //       ),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AppBloc, AppState>(
            listener: (context, state) {
              Timer(const Duration(milliseconds: 1500), () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => state.status == AppStatus.unauthenticated
                        ? AuthorizationPage()
                        : DashboardPage(),
                    transitionDuration: Duration.zero,
                  ),
                );
              });
            },
        ),
        BlocListener<ObjectsBloc, ObjectsState>(
          listener: (context, state) {
            // TODO: implement listener
          },
        ),
      ],
      child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SvgPicture.asset(
                      'assets/logos/logo.svg',
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  ),
                ],
              ),
            ),
    ));
  }
}
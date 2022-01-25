import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_management/authentication/bloc/authentication_bloc.dart';
import 'package:property_management/authentication/bloc/authentication_event.dart';
import 'package:property_management/authentication/bloc/authentication_state.dart';
import 'package:property_management/authentication/pages/authorization_page.dart';
import 'package:property_management/dashboard/dashboard_page.dart';
import 'package:property_management/theme/styles.dart';

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
      body: BlocListener<AppBloc, AppState>(
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
      )
    );
  }
}
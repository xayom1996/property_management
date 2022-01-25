import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/authentication/bloc/authentication_bloc.dart';
import 'package:property_management/dashboard/dashboard_page.dart';
import 'package:property_management/splash_page.dart';
import 'package:property_management/theme/box_ui.dart';
import 'package:property_management/total/pages/total_charts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:property_management/utils/user_repository.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: kBackgroundColor, // status bar color
    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    statusBarBrightness: Brightness.light,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final userRepository = UserRepository();
  await userRepository.user.first;

  // await authenticationRepository.logInWithEmailAndPassword(email: 'xayom1996@gmail.com', password: 'povibi80');
  // print(userRepository.currentUser.id);
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  // userRepository.firestore
  //     .collection('users')
  //     .get()
  //     .then((QuerySnapshot querySnapshot) {
  //   querySnapshot.docs.forEach((doc) {
  //     print(doc['email']);
  //   });
  // });
  return runApp(
    DevicePreview(
      // enabled: !kReleaseMode,
      enabled: false,
      builder: (context) => App(
        userRepository: userRepository,
      ), // Wrap your app
    ),
  );
}

class App extends StatelessWidget {
  const App({
    Key? key,
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(key: key);

  final UserRepository _userRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _userRepository,
      child: BlocProvider(
        create: (_) => AppBloc(
          userRepository: _userRepository,
        ),
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: () => MaterialApp(
            title: 'Управление недвижимостью',
            theme: ThemeData(
              // primarySwatch: Colors.blue,
              backgroundColor: kBackgroundColor,
              appBarTheme: AppBarTheme(
                backgroundColor: kBackgroundColor,
                elevation: 0,
              ),
            ),
            // useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            home: SplashPage(),
            // home: DashboardPage(),
            // home: TotalCharts(title: ''),
          )
        ),
      ),
    );
  }
}

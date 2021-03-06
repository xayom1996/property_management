import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/dashboard/dashboard_page.dart';
import 'package:property_management/splash_page.dart';
import 'package:property_management/theme/box_ui.dart';
import 'package:property_management/total/pages/total_charts.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: kBackgroundColor, // status bar color
    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    statusBarBrightness: Brightness.light,
  ));

  return runApp(
    DevicePreview(
      // enabled: !kReleaseMode,
      enabled: false,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
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
        builder: kReleaseMode
            ? (context, child) {
                final mediaQueryData = MediaQuery.of(context);
                return MediaQuery(
                  data: mediaQueryData.copyWith(textScaleFactor: 1.0),
                  child: child!,
                );
              }
            : DevicePreview.appBuilder,
        home: SplashPage(),
        // home: DashboardPage(),
        // home: TotalCharts(title: ''),
      )
    );
  }
}

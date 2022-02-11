import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:property_management/account/cubit/change_password/change_password_cubit.dart';
import 'package:property_management/account/cubit/personal_info/personal_info_cubit.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/services/firestore_service.dart';
import 'package:property_management/authentication/cubit/auth/auth_cubit.dart';
import 'package:property_management/authentication/cubit/recovery_password/recovery_password_cubit.dart';
import 'package:property_management/bloc_observer.dart';
import 'package:property_management/characteristics/cubit/characteristics_cubit.dart';
import 'package:property_management/dashboard/cubit/dashboard_cubit.dart';
import 'package:property_management/dashboard/dashboard_page.dart';
import 'package:property_management/objects/bloc/objects_bloc.dart';
import 'package:property_management/objects/cubit/add_object/add_object_cubit.dart';
import 'package:property_management/objects/cubit/add_tenant/add_tenant_cubit.dart';
import 'package:property_management/objects/cubit/edit_object/edit_object_cubit.dart';
import 'package:property_management/objects/cubit/edit_tenant/edit_tenant_cubit.dart';
import 'package:property_management/splash_page.dart';
import 'package:property_management/app/theme/box_ui.dart';
import 'package:property_management/total/pages/total_charts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:property_management/app/services/user_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: kBackgroundColor, // status bar color
    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    statusBarBrightness: Brightness.light,
  ));

  await Hive.initFlutter();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final userRepository = UserRepository();
  await userRepository.user.first;

  final fireStoreService = FireStoreService();

  final appBloc = AppBloc(userRepository: userRepository, fireStoreService: fireStoreService);

  return BlocOverrides.runZoned(
    () => runApp(
        DevicePreview(
          enabled: !kReleaseMode,
          // enabled: false,
          builder: (context) => App(
              userRepository: userRepository,
              fireStoreService: fireStoreService,
              appBloc: appBloc,
          ), // Wrap your app
        ),
    ),
    blocObserver: SimpleBlocObserver(),
  );
}

class App extends StatelessWidget {
  const App({
    Key? key,
    required UserRepository userRepository,
    required FireStoreService fireStoreService,
    required AppBloc appBloc,
  })  : _userRepository = userRepository,
        _fireStoreService = fireStoreService,
        _appBloc = appBloc,
        super(key: key);

  final UserRepository _userRepository;
  final FireStoreService _fireStoreService;
  final AppBloc _appBloc;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _userRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => _appBloc),
          BlocProvider(create: (_) => AuthCubit(_userRepository)),
          BlocProvider(create: (_) => RecoveryPasswordCubit(_userRepository)),
          BlocProvider(create: (_) => PersonalInfoCubit(_userRepository)),
          BlocProvider(create: (_) => ChangePasswordCubit(_userRepository)),
          BlocProvider(create: (_) => DashboardCubit()),
          BlocProvider(create: (_) => ObjectsBloc(appBloc: _appBloc,
            fireStoreService: _fireStoreService)),
          BlocProvider(create: (_) => CharacteristicsCubit()),
          BlocProvider(create: (_) => AddObjectCubit(fireStoreService: _fireStoreService,
              appBloc: _appBloc)),
          BlocProvider(create: (_) => EditObjectCubit(fireStoreService: _fireStoreService)),
          BlocProvider(create: (_) => AddTenantCubit(fireStoreService: _fireStoreService,
              appBloc: _appBloc)),
          BlocProvider(create: (_) => EditTenantCubit(fireStoreService: _fireStoreService)),
        ],
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

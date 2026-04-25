import 'package:bull_station/bloc_obs.dart';
import 'package:bull_station/core/utils/screens/splash_screen.dart';
import 'package:bull_station/features/booking/application/booking_cubit.dart';
import 'package:bull_station/features/home/application/category_cubit/category_cubit.dart';
import 'package:bull_station/features/home/application/home_cubit/home_cubit.dart';
import 'package:bull_station/features/home/application/notification_cubit/notification_cubit.dart';
import 'package:bull_station/features/profile/application/profile_cubit.dart';
import 'package:bull_station/firebase_options.dart';
import 'package:bull_station/l10n/app_localizations.dart';
import 'package:bull_station/notification_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// معالج إشعارات الخلفية
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. تهيئة فايربيز
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // 2. تهيئة الإشعارات عبر الهيلبر
  await NotificationHelper().init();
  
  // 3. ضبط معالج الخلفية
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 4. إعدادات الـ Bloc
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => CategoryCubit()..getAllCategories()),
          BlocProvider(create: (context) => HomeCubit()..initUser()),
          BlocProvider(create: (context) => BookingCubit()),
          BlocProvider(create: (context) => ProfileCubit()),
          BlocProvider(create: (context) => NotificationCubit()),
        ],
        child: MaterialApp(
          title: 'Bull Station',
          debugShowCheckedModeBanner: false,
          // إعدادات اللغة
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), 
            Locale('ar', ''), 
          ],
          locale: const Locale('ar'), // يمكنك جعلها ديناميكية لاحقاً
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
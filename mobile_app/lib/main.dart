import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/screens/MainScreen.dart';
import 'package:mobile_app/screens/screens.dart';
import 'package:mobile_app/util/auth.dart';
import './screens/SplashScreen.dart';
import 'package:provider/provider.dart';
import './screens/RegisterScreen.dart';
import './screens/LoginScreen.dart';
import 'screens/driver/DriverHomeScreen.dart';
import 'screens/driver/DriverHistoryScreen.dart';
import 'screens/rider/RiderHomeScreen.dart';
import 'screens/rider/RiderHistoryScreen.dart';
import 'screens/driver/DriverDashboardScreen.dart';
import 'screens/rider/RiderDashboardScreen.dart';
import 'screens/ForgotPassword.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Auth>(
          create: (_) => Auth(FirebaseAuth.instance),
        ),
        StreamProvider(
          initialData: null,
          create: (context) => context.read<Auth>().authStateChanges,
        ),
      ],
      child: MaterialApp(
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          MainScreen.id: (context) => MainScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          ForgotPassword.id: (context) => ForgotPassword(),
          DriverHomeScreen.id: (context) => DriverHomeScreen(),
          DriverHistoryScreen.id: (context) => DriverHistoryScreen(),
          RiderHomeScreen.id: (context) => RiderHomeScreen(),
          RiderHistoryScreen.id: (context) => RiderHistoryScreen(),
          DriverDashboardScreen.id: (context) => DriverDashboardScreen(),
          RiderDashboardScreen.id: (context) => RiderDashboardScreen(),
        },
      ),
    );
  }
}

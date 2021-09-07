import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_app/screens/MainScreen.dart';
import 'package:mobile_app/util/auth.dart';
import './screens/SplashScreen.dart';
import 'package:provider/provider.dart';
import './screens/RegisterScreen.dart';
import './screens/LoginScreen.dart';
import 'screens/DriverHomeScreen.dart';
import 'screens/DriverHistoryScreen.dart';
import 'screens/RiderHomeScreen.dart';
import 'screens/RiderHistoryScreen.dart';
import 'screens/DriverDashboardScreen.dart';
import 'screens/RiderDashboardScreen.dart';
import 'screens/ForgotPassword.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
  // This widget is the root of your application.

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
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
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

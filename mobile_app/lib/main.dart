import 'package:flutter/material.dart';
import 'package:mobile_app/screens/MainScreen.dart';
import './screens/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff33415C),
        accentColor: Color(0xff0466C8),
        accentIconTheme: IconThemeData(
          color: Colors.red,
          size: 10,
        ),
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        MainScreen.id: (context) => MainScreen(),
      },
    );
  }
}

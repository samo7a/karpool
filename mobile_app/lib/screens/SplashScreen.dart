import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mobile_app/screens/MainScreen.dart';
import '../util/Size.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'splashScreen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseFunctions functions = FirebaseFunctions.instance;

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  startTime() async {
    var duration = new Duration(seconds: 2);
    return new Timer(duration, route);
  }

  route() {
    final user = Provider.of<User?>(context, listen: false);
    
    if (user != null) {
      //TODO: figure out the type of user
      //call the getProfile function from firebase
      //if(driver) return driverHomePage()
      //if(rider) return riderHomePage(0)
    } else
      Navigator.pushNamed(context, MainScreen.id);
  }

  initScreen(BuildContext context) {
    Size size = Size(Context: context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff001845),
            Color(0xffffffff),
            Color(0xff001845),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('images/splashIcon.png'),
              width: size.BLOCK_WIDTH * 50,
              height: size.BLOCK_HEIGHT * 50,
            ),
            SpinKitFadingCircle(
              color: Color(0xff002855),
              size: size.BLOCK_WIDTH * 15,
            ),
          ],
        ),
      ),
    );
  }
}

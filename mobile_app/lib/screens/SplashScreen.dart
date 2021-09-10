import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mobile_app/screens/MainScreen.dart';
import 'package:mobile_app/screens/rider/RiderDashboardScreen.dart';
import 'package:mobile_app/util/Auth.dart';
import '../util/Size.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'driver/DriverDashboardScreen.dart';

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

  route() async {
    try {
      print("start try");
      final user = Provider.of<User?>(context, listen: false);
      // final user = context.read<Auth>().getCurrentUser();
      // bool v = user.emailVerified;
      final prefs = await SharedPreferences.getInstance();
      HttpsCallable getUser = FirebaseFunctions.instance.httpsCallable.call('account-getUser');
      String role = await prefs.getString("role") as String;
      print("role: " + role);
      if (role == 'norole')
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
          (Route<dynamic> route) => false,
        );
      bool isDriver = role == 'driver';
      print(isDriver);
      if (user != null && !user.emailVerified) {
        String uid = user.uid;
        print(uid);
        final obj = <String, dynamic>{
          "uid": uid,
          "driver": isDriver,
        };
        final result = await getUser(obj);
        var riderRole = result.data['roles']['Rider'];
        var driverRole = result.data["roles"]["Driver"];
        print(riderRole + driverRole);
        if (isDriver == true && driverRole != null) {
          //the user is driver
          print("i am a driver");
          prefs.setString("role", "driver");
          EasyLoading.dismiss();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DriverDashboardScreen()),
            (Route<dynamic> route) => false,
          );
        } else if (isDriver == false && riderRole != null) {
          // the user is a rider
          print("i am a rider");
          prefs.setString("role", "rider");
          EasyLoading.dismiss();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => RiderDashboardScreen()),
            (Route<dynamic> route) => false,
          );
        } else {
          print("i am nothing");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        print("end if else");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print("error");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
        (Route<dynamic> route) => false,
      );
    }
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

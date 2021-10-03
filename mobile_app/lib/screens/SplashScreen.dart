import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/screens/MainScreen.dart';
import 'package:mobile_app/screens/rider/RiderDashboardScreen.dart';
import 'package:mobile_app/util/Auth.dart';
import '../util/Size.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'driver/DriverDashboardScreen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splashScreen';
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
    User currentUser = Provider.of<User>(context, listen: false);
    try {
      final user = await Provider.of<Auth>(context, listen: false).currentUser();
      if (user == null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          MainScreen.id,
          (Route<dynamic> route) => false,
        );
        return;
      }
      currentUser.setFirstName = user.firstName;
      currentUser.setLastName = user.lastName;
      currentUser.setEmail = user.email;
      currentUser.setUid = user.uid;
      currentUser.setIsDriver = user.isDriver;
      currentUser.setIsRider = user.isRider;
      currentUser.setIsVerified = user.isVerified;
      currentUser.setPhoneNumber = user.phoneNumber;
      currentUser.setRating = user.rating;
      currentUser.setProfileURL = user.profileURL;

      bool verified = user.isVerified;
      if (!verified) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          MainScreen.id,
          (Route<dynamic> route) => false,
        );
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      String role = prefs.getString("role") ?? 'norole';
      if (role == 'norole') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          MainScreen.id,
          (Route<dynamic> route) => false,
        );
        return;
      }
      bool isDriver = role == 'driver';
      if (isDriver) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          DriverDashboardScreen.id,
          (Route<dynamic> route) => false,
        );
        return;
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RiderDashboardScreen.id,
          (Route<dynamic> route) => false,
        );
        return;
      }
    } catch (e) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainScreen.id,
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

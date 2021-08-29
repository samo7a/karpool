import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_app/screens/MainScreen.dart';
import '../util/Size.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'splachScreen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() {
      Navigator.of(context).pushNamed(MainScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
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

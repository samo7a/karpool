import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_app/screens/MainScreen.dart';
import '../util/Size.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'splachScreen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   Future(() {
  //     Navigator.of(context).pushNamed(MainScreen.id);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
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
      child: FutureBuilder(
        future: _firebaseApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error"); //TODO: create a better error screen.
          } else if (snapshot.hasData) {
            return MainScreen();
          } else {
            return Center(
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
            );
          }
        },
      ),
    );
  }
}

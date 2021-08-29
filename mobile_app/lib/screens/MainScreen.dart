import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../util/Size.dart';

class MainScreen extends StatelessWidget {
  static const id = 'mainScreen';
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xFF9DA9C1),
          body: SafeArea(
              child: Center(
            child: Column(
              children: [
                Image(
                  image: AssetImage('images/splashIcon.png'),
                  width: size.BLOCK_WIDTH * 60,
                  height: size.BLOCK_HEIGHT * 60,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    minWidth: size.BLOCK_WIDTH * 80,
                    height: size.BLOCK_HEIGHT * 10,
                    color: Color(0xFF0466CB),
                    child: Text('Existing Karpool User',
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    minWidth: size.BLOCK_WIDTH * 80,
                    height: size.BLOCK_HEIGHT * 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    color: Color(0xFF0466CB),
                    child: Text('New Karpool User',
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          )),
        ));
  }
}

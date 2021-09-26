import 'package:flutter/material.dart';
// import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/util/constants.dart';

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({Key? key}) : super(key: key);
  static const String id = "vehicleInfo";
  @override
  _VehicleInfoScreen createState() => _VehicleInfoScreen();
}

class _VehicleInfoScreen extends State<VehicleInfoScreen> {
  @override
  Widget build(BuildContext context) {
    //final user = ModalRoute.of(context)!.settings.arguments as User;
    // final car = ModalRoute.of(context)!.settings.arguments as Car;

    // String email = user.email;  later;

    return Scaffold(
      backgroundColor: Color(0xff33415C),
      appBar: AppBar(
        backgroundColor: Color(0xff33415C),
        title: Text("Vehicle"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: kWhite,
          ),
        ),
      ),
      body: Center(
        child: Column(
          // just for testing
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Vehicle Info for drivers',
            ),
            Text(
              "Pass the vechile info here",
            ),
            Text(
              'Add Init state',
            ),
          ],
        ),
      ),
    );
  }
}

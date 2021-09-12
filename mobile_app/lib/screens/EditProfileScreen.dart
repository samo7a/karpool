import 'package:flutter/material.dart';
import 'package:mobile_app/models/User.dart';

class EditProfilScreen extends StatefulWidget {
  const EditProfilScreen({Key? key}) : super(key: key);
  static const String id = "editProfilScreen";
  @override
  _EditProfilScreenState createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    String fname = user.firstName;
    String lname = user.lastName;
    String phone = user.phoneNumber;
    // String email = user.email;  later;

    return Scaffold(
      backgroundColor: Color(0xff33415C),
      appBar: AppBar(
        backgroundColor: Color(0xff33415C),
        title: Text("Edit"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          // just for testing
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Edit Profile for both Drivers and Riders',
            ),
            Text(
              "$fname",
            ),
            Text(
              '$lname',
            ),
            Text(
              '$phone',
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_app/util/constants.dart';

class BankInfoScreen extends StatefulWidget {
  const BankInfoScreen({Key? key}) : super(key: key);
  static const String id = "bankInfo";
  @override
  _BankInfoScreen createState() => _BankInfoScreen();
}

class _BankInfoScreen extends State<BankInfoScreen> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Color(0xff33415C),
      appBar: AppBar(
        backgroundColor: Color(0xff33415C),
        title: Text("BankInfoScreen"),
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
              'Bank Info for drivers',
            ),
            Text(
              "Pass the bank info here",
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

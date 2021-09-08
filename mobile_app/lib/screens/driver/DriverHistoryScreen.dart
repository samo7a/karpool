import 'package:flutter/material.dart';

class DriverHistoryScreen extends StatefulWidget {
  static const id = 'driverHistoryScreen';
  const DriverHistoryScreen({ Key? key }) : super(key: key);

  @override
  _DriverHistoryScreenState createState() => _DriverHistoryScreenState();
}

class _DriverHistoryScreenState extends State<DriverHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(
              'Driver History',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }
}
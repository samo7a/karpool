import 'package:flutter/material.dart';
import 'package:mobile_app/screens/driver/DriverHistoryScreen.dart';
import 'DriverHomeScreen.dart';
import 'DriverHistoryScreen.dart';
import 'package:mobile_app/pallete.dart';
import 'package:mobile_app/widgets/DriverDrawer.dart';
import 'package:mobile_app/widgets/TabHandler.dart';

class DriverDashboardScreen extends StatefulWidget {
  static const id = 'driverDashboardScreen';
  const DriverDashboardScreen({Key? key}) : super(key: key);

  @override
  _DriverDashboardScreenState createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(''), 
          backgroundColor: kButtonColor,
        ),
        drawer: DriverDrawer(), 
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            bottomNavigationBar: TabHandler(),
            body: TabBarView(
              children: [
                DriverHomeScreen(),
                DriverHistoryScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




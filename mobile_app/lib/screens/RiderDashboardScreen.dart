import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/RiderDrawer.dart';
import 'RiderHomeScreen.dart';
import 'RiderHistoryScreen.dart';
import 'package:mobile_app/pallete.dart';
import 'package:mobile_app/widgets/TabHandler.dart';

class RiderDashboardScreen extends StatefulWidget {
  static const id = 'riderDashboardScreen';
  const RiderDashboardScreen({Key? key}) : super(key: key);

  @override
  _RiderDashboardScreenState createState() => _RiderDashboardScreenState();
}

class _RiderDashboardScreenState extends State<RiderDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(''), 
          backgroundColor: kButtonColor,
        ),
        drawer: RiderDrawer(), 
        body: DefaultTabController(
          length: 2,
          child: Scaffold(
            bottomNavigationBar: TabHandler(),
            body: TabBarView(
              children: [
                RiderHomeScreen(),
                RiderHistoryScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




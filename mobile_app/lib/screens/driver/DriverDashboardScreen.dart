import 'package:flutter/material.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/screens/driver/DriverHistoryScreen.dart';
import 'DriverHomeScreen.dart';
import 'DriverHistoryScreen.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/DriverDrawer.dart';
import 'package:mobile_app/widgets/TabHandler.dart';

class DriverDashboardScreen extends StatelessWidget {
  static const String id = 'driverDashboardScreen';
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: kButtonColor,
      ),
      drawer: DriverDrawer(
        user: user,
      ),
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
    );
  }
}

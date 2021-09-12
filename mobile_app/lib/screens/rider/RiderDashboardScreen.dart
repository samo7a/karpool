import 'package:flutter/material.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/widgets/RiderDrawer.dart';
import 'RiderHomeScreen.dart';
import 'RiderHistoryScreen.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/TabHandler.dart';

class RiderDashboardScreen extends StatelessWidget {
  static const String id = 'riderDashboardScreen';
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: kButtonColor,
      ),
      drawer: RiderDrawer(
        user: user,
      ),
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
    );
  }
}

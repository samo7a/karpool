import 'package:flutter/material.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/screens/driver/DriverHistoryScreen.dart';
import 'package:mobile_app/util/constants.dart';
import 'DriverHomeScreen.dart';
import 'DriverHistoryScreen.dart';
import 'package:mobile_app/widgets/DriverDrawer.dart';
import 'package:mobile_app/widgets/TabHandler.dart';

class DriverDashboardScreen extends StatefulWidget {
  static const String id = 'driverDashboardScreen';

  @override
  _DriverDashboardScreenState createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  String title = "Dashboard";
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: Text("$title"),
        backgroundColor: kDashboardColor,
        centerTitle: true,
      ),
      drawer: DriverDrawer(
        user: user,
      ),
      body: DefaultTabController(
        length: 2,
        child: Builder(
          builder: (BuildContext context) {
            final TabController tabController = DefaultTabController.of(context)!;
            tabController.addListener(() {
              if (!tabController.indexIsChanging) {
                if (tabController.index == 0)
                  setState(() {
                    title = "Dashboard";
                  });
                else
                  setState(() {
                    title = "History";
                  });
              }
            });
            return Scaffold(
              bottomNavigationBar: TabHandler(),
              body: TabBarView(
                controller: tabController,
                children: [
                  DriverHomeScreen(),
                  DriverHistoryScreen(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

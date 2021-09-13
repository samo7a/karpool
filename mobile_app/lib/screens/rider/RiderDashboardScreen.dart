import 'package:flutter/material.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/RiderDrawer.dart';
import 'RiderHomeScreen.dart';
import 'RiderHistoryScreen.dart';
import 'package:mobile_app/widgets/TabHandler.dart';

class RiderDashboardScreen extends StatefulWidget {
  static const String id = 'riderDashboardScreen';

  @override
  _RiderDashboardScreenState createState() => _RiderDashboardScreenState();
}

class _RiderDashboardScreenState extends State<RiderDashboardScreen> {
  String title = "Dashboard";
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
        backgroundColor: kDashboardColor,
        centerTitle: true,
      ),
      drawer: RiderDrawer(
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
                  RiderHomeScreen(),
                  RiderHistoryScreen(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

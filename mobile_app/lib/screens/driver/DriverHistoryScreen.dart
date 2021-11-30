import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/screens/driver/DriverDepositsScreen.dart';
import 'package:mobile_app/screens/driver/DriverEarningsScreen.dart';
import 'package:mobile_app/screens/driver/DriverRidesHistoryScreen.dart';
import 'package:mobile_app/util/constants.dart';

class DriverHistoryScreen extends StatefulWidget {
  const DriverHistoryScreen({Key? key}) : super(key: key);

  @override
  _DriverHistoryScreenState createState() => _DriverHistoryScreenState();
}

class _DriverHistoryScreenState extends State<DriverHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: kDashboardColor,
            flexibleSpace: TabBar(
              indicatorWeight: 1,
              labelColor: kWhite,
              unselectedLabelColor: Colors.white70,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: kWhite,
              tabs: [
                Tab(
                  text: 'Rides',
                  icon: Icon(
                    Icons.history,
                  ),
                ),
                Tab(
                  text: 'Earnings',
                  icon: Icon(
                    Icons.attach_money,
                  ),
                ),
                Tab(
                  text: 'Deposits',
                  icon: Icon(
                    FontAwesomeIcons.moneyBill,
                  ),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              DriverRidesHistoryScreen(),
              DriverEarningsScreen(),
              DriverDepositsScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

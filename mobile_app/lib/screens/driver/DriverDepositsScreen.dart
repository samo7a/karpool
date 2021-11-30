import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/DepositContainer.dart';
import 'package:provider/provider.dart';

class DriverDepositsScreen extends StatefulWidget {
  const DriverDepositsScreen({Key? key}) : super(key: key);

  @override
  _DriverDepositsScreenState createState() => _DriverDepositsScreenState();
}

class _DriverDepositsScreenState extends State<DriverDepositsScreen> {
  String depositAccount = '';
  List<Map<String, dynamic>> weeklyData = [];
  void setChartData() async {
    HttpsCallable getEarnings = FirebaseFunctions.instance.httpsCallable("account-getEarnings");
    try {
      final result = await getEarnings();
      int weeklyDataLength = result.data[0].length;
      // print(result.data[0].length); //weeks
      for (int i = 0; i < weeklyDataLength; i++) {
        setState(() {
          double amount = result.data[0][i]["amount"] * 1.0;
          String date = setDateRange(i);
          weeklyData.add({"date": date, "amount": amount});
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  String setDateRange(int weekIndex) {
    final date = new DateTime.now();
    final startOfYear = new DateTime(date.year, 1, 1, 0, 0);
    DateTime start = startOfYear.add(Duration(days: 14 * weekIndex - 4));
    return start.month.toString() + "-" + start.day.toString() + "-" + start.year.toString();
  }

  void initState() {
    super.initState();
    setChartData();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    depositAccount = user.accountNum!.substring(6, 10);
    return Container(
      color: kDashboardColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var item in weeklyData)
              if (item['amount'] != 0)
                DepositContainer(
                  depositDate: item['date'],
                  depositAccount: depositAccount,
                  amount: item['amount'],
                ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/DepositContainer.dart';


class DriverDepositsScreen extends StatefulWidget {
  const DriverDepositsScreen({Key? key}) : super(key: key);

  @override
  _DriverDepositsScreenState createState() => _DriverDepositsScreenState();
}

class _DriverDepositsScreenState extends State<DriverDepositsScreen> {
  String depositDate = '08/09/2021';
  String depositAccount = '3635';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kDashboardColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DepositContainer(
              depositDate: depositDate,
              depositAccount: depositAccount,
            ),
          ],
        ),
      ),
    );
  }
}

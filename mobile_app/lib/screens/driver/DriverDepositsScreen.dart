import 'package:flutter/material.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/DepositContainer.dart';


class DriverDepositsScreen extends StatefulWidget {
  const DriverDepositsScreen({Key? key}) : super(key: key);

  @override
  _DriverDepositsScreenState createState() => _DriverDepositsScreenState();
}

class _DriverDepositsScreenState extends State<DriverDepositsScreen> {
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
              depositDate: '11/08/2021',
              depositAccount: depositAccount,
            ),
            DepositContainer(
              depositDate: '10/14/2021',
              depositAccount: depositAccount,
            ),
            DepositContainer(
              depositDate: '09/22/2021',
              depositAccount: depositAccount,
            ),
            DepositContainer(
              depositDate: '09/13/2021',
              depositAccount: depositAccount,
            ),
            DepositContainer(
              depositDate: '09/02/2021',
              depositAccount: depositAccount,
            ),
            DepositContainer(
              depositDate: '08/24/2021',
              depositAccount: depositAccount,
            ),
            DepositContainer(
              depositDate: '06/14/2021',
              depositAccount: depositAccount,
            ),
            DepositContainer(
              depositDate: '04/27/2021',
              depositAccount: depositAccount,
            ),
          ],
        ),
      ),
    );
  }
}

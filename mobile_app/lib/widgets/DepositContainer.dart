import 'package:flutter/cupertino.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:flutter/material.dart';

class DepositContainer extends StatelessWidget {
  const DepositContainer({
    Key? key,
    required this.depositDate,
    required this.depositAccount,
    required this.amount,
  }) : super(key: key);

  final String depositDate;
  final String depositAccount;
  final double amount;

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return Padding(
      padding: EdgeInsets.only(
        top: size.BLOCK_HEIGHT * 3,
        bottom: size.BLOCK_HEIGHT * 0.25,
      ),
      child: Container(
        width: size.BLOCK_WIDTH * 78,
        height: size.BLOCK_HEIGHT * 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: kTripContainerColor,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: size.BLOCK_WIDTH * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                depositDate,
                style: TextStyle(
                  color: kWhite,
                  fontFamily: 'Glory',
                  fontWeight: FontWeight.bold,
                  fontSize: size.FONT_SIZE * 20,
                ),
              ),
              SizedBox(
                width: size.BLOCK_WIDTH * 1.5,
              ),
              Divider(
                // height: size.BLOCK_WIDTH,
                color: kWhite,
                thickness: 1,
              ),
              SizedBox(
                width: size.BLOCK_WIDTH * 1.5,
              ),
              Expanded(
                child: Text(
                  "Deposit initiated to account ending in $depositAccount",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: kWhite,
                    fontFamily: 'Glory',
                    fontWeight: FontWeight.bold,
                    fontSize: size.FONT_SIZE * 20,
                  ),
                ),
              ),
              Divider(
                // height: size.BLOCK_WIDTH,
                color: kWhite,
                thickness: 1,
              ),
              SizedBox(
                width: size.BLOCK_WIDTH * 1.5,
              ),
              Text(
                "\$$amount",
                style: TextStyle(
                  color: Colors.green[700],
                  fontSize: size.FONT_SIZE * 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

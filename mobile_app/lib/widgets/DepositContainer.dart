import 'package:flutter/cupertino.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:flutter/material.dart';

class DepositContainer extends StatelessWidget {
  const DepositContainer({
    Key? key,
    required this.depositDate,
    required this.depositAccount,
  }) : super(key: key);

  final String depositDate;
  final String depositAccount;

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
        height: size.BLOCK_HEIGHT * 7.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: kTripContainerColor,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: size.BLOCK_WIDTH * 2),
          child: Row(
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
              VerticalDivider(
                width: size.BLOCK_WIDTH,
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
            ],
          ),
        ),
      ),
    );
  }
}

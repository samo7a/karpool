import 'package:flutter/material.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';

class TripResultContainer extends StatelessWidget {
  const TripResultContainer({
    Key? key,
    required this.date,
    required this.time,
    required this.fromAddress,
    required this.toAddress,
    required this.profilePic,
    required this.estimatedPrice,
    // required this.onPress,
  }) : super(key: key);

  final String date;
  final String time;
  final String fromAddress;
  final String toAddress;
  final String profilePic;
  final String estimatedPrice;
  // final Function onPress;

  // TODO: add button for scheduling rides

  @override
  Widget build(BuildContext context) {
    Size size = new Size(Context: context);
    return Padding(
      padding: const EdgeInsets.only(
        top: 24.0,
        bottom: 1,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: size.BLOCK_HEIGHT * 7,
                width: size.BLOCK_WIDTH * 78,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: kTripContainerColor,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            date,
                            style: TextStyle(
                              color: kWhite,
                              fontFamily: 'Glory',
                              fontWeight: FontWeight.bold,
                              fontSize: size.FONT_SIZE * 20,
                            ),
                          ),
                          SizedBox(height: size.BLOCK_HEIGHT * 0.5),
                          Text(
                            time,
                            style: TextStyle(
                              color: kWhite,
                              fontFamily: 'Glory',
                              fontWeight: FontWeight.bold,
                              fontSize: size.FONT_SIZE * 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      color: kWhite,
                      thickness: size.BLOCK_WIDTH * 0.75,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From: ' + fromAddress,
                            style: TextStyle(
                              color: kWhite,
                              fontFamily: 'Glory',
                              fontWeight: FontWeight.bold,
                              fontSize: size.FONT_SIZE * 20,
                            ),
                          ),
                          SizedBox(height: size.BLOCK_HEIGHT * 0.5),
                          Text(
                            'To: ' + toAddress,
                            style: TextStyle(
                              color: kWhite,
                              fontFamily: 'Glory',
                              fontWeight: FontWeight.bold,
                              fontSize: size.FONT_SIZE * 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      color: kWhite,
                      thickness: size.BLOCK_WIDTH * 0.75,
                    ),
                    Text(
                      '\$ ' + estimatedPrice,
                      style: TextStyle(
                        color: kWhite,
                        fontFamily: 'Glory',
                        fontWeight: FontWeight.bold,
                        fontSize: size.FONT_SIZE * 20,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: size.BLOCK_WIDTH * 3,
              ),
              Container(
                width: size.BLOCK_WIDTH * 14,
                height: size.BLOCK_HEIGHT * 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      profilePic,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

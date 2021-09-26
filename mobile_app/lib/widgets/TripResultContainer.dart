import 'package:flutter/material.dart';
import 'package:mobile_app/models/RiderTrip.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';

import '../util/HeroDialog.dart';
import 'DriverModal.dart';

class TripResultContainer extends StatelessWidget {
  const TripResultContainer({
    Key? key,
    // required this.date,
    // required this.time,
    // // required this.fromAddress,
    // // required this.toAddress,
    // required this.profilePic,
    // required this.fullName,
    // required this.starRating,
    // required this.estimatedPrice,
    // required this.status,
    // required this.onPress,
    required this.trip,
  }) : super(key: key);

  // final String date;
  // final String time;
  // // final String fromAddress;
  // // final String toAddress;
  // final String profilePic;
  // final String estimatedPrice;
  // final String status;
  // // final Function onPress;
  // final String fullName;
  // final int starRating; //change to double later
  final RiderTrip trip;

  // TODO: add button for scheduling rides

  @override
  Widget build(BuildContext context) {
    Size size = new Size(Context: context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) {
              return DriverModal(
                show: true,
                trip: trip,
                driverId: trip.driverId,
              );
            },
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: size.BLOCK_HEIGHT * 3,
          bottom: size.BLOCK_HEIGHT * 0.25,
        ),
        child: Container(
          width: size.BLOCK_WIDTH * 78,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: kTripContainerColor,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: size.BLOCK_WIDTH * 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: size.BLOCK_HEIGHT * 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.date_range_outlined,
                    ),
                    SizedBox(
                      width: size.BLOCK_WIDTH * 3,
                    ),
                    Text(
                      trip.date,
                      style: TextStyle(
                        color: kWhite,
                        fontFamily: 'Glory',
                        fontWeight: FontWeight.bold,
                        fontSize: size.FONT_SIZE * 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.BLOCK_HEIGHT * 1,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.timelapse_outlined,
                    ),
                    SizedBox(
                      width: size.BLOCK_WIDTH * 3,
                    ),
                    Text(
                      trip.time,
                      style: TextStyle(
                        color: kWhite,
                        fontFamily: 'Glory',
                        fontWeight: FontWeight.bold,
                        fontSize: size.FONT_SIZE * 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.BLOCK_HEIGHT * 1,
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         Icon(
                //           Icons.location_searching,
                //           color: Colors.green[800],
                //         ),
                //         SizedBox(
                //           width: size.BLOCK_WIDTH * 3,
                //         ),
                //         Expanded(
                //           child: Text(
                //             fromAddress,
                //             maxLines: 10,
                //             overflow: TextOverflow.ellipsis,
                //             softWrap: false,
                //             style: TextStyle(
                //               color: kWhite,
                //               fontFamily: 'Glory',
                //               fontWeight: FontWeight.bold,
                //               fontSize: size.FONT_SIZE * 20,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //     Padding(
                //       padding: EdgeInsets.only(left: size.BLOCK_WIDTH * 0.1),
                //       child: Icon(
                //         Icons.arrow_downward,
                //         size: size.BLOCK_HEIGHT * 3,
                //       ),
                //     ),
                //     Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         Icon(
                //           Icons.pin_drop_outlined,
                //           color: Colors.red,
                //         ),
                //         SizedBox(
                //           width: size.BLOCK_WIDTH * 3,
                //         ),
                //         Expanded(
                //           child: Text(
                //             toAddress,
                //             maxLines: 10,
                //             overflow: TextOverflow.ellipsis,
                //             softWrap: false,
                //             style: TextStyle(
                //               color: kWhite,
                //               fontFamily: 'Glory',
                //               fontWeight: FontWeight.bold,
                //               fontSize: size.FONT_SIZE * 20,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //     SizedBox(
                //       height: size.BLOCK_HEIGHT * 1,
                //     ),

                //   ],
                // ),
                Center(
                  child: Text(
                    '\$ ' + trip.estimatedPrice.toString(),
                    style: TextStyle(
                      color: Colors.green[900],
                      fontFamily: 'Glory',
                      fontWeight: FontWeight.bold,
                      fontSize: size.FONT_SIZE * 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.BLOCK_HEIGHT * 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

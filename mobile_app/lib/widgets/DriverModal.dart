import 'dart:ui';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile_app/models/RiderTrip.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/util/constants.dart';

class DriverModal extends StatelessWidget {
  const DriverModal({
    Key? key,
    // required this.profilePic,
    // required this.fullName,
    // required this.starRating,
    // required this.date,
    // required this.time,
    // required this.estimatedPrice,
    required this.trip,
  }) : super(key: key);

  // final String profilePic;
  // final String fullName;
  // final int starRating; //change to double later
  // final String date;
  // final double estimatedPrice;
  // final String time;
  final RiderTrip trip;
  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Material(
          color: Color(0xff0353A4),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Container(
                      width: size.BLOCK_WIDTH * 32,
                      height: size.BLOCK_HEIGHT * 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            trip.driver.profileURL,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Center(
                        child: Text(
                          "Your Driver: " + trip.driver.firstName + " " + trip.driver.lastName,
                          style: TextStyle(
                            fontFamily: 'Glory',
                            fontSize: size.FONT_SIZE * 24,
                            fontWeight: FontWeight.bold,
                            color: kWhite,
                          ),
                        ),
                      ),
                      SizedBox(height: size.BLOCK_HEIGHT * 1),
                    ],
                  ),
                  Center(
                    child: RatingBarIndicator(
                      rating: trip.driver.rating.ceilToDouble(), // remove the ceil function later
                      itemCount: 5,
                      itemSize: size.BLOCK_WIDTH * 12,
                      direction: Axis.horizontal,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: kStarsColor,
                      ),
                    ),
                  ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_searching,
                            color: Colors.green[800],
                          ),
                          SizedBox(
                            width: size.BLOCK_WIDTH * 3,
                          ),
                          Expanded(
                            child: Text(
                              trip.fromAddress,
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
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
                      Padding(
                        padding: EdgeInsets.only(left: size.BLOCK_WIDTH * 0.1),
                        child: Icon(
                          Icons.arrow_downward,
                          size: size.BLOCK_HEIGHT * 3,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pin_drop_outlined,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: size.BLOCK_WIDTH * 3,
                          ),
                          Expanded(
                            child: Text(
                              trip.toAddress,
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
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
                      SizedBox(
                        height: size.BLOCK_HEIGHT * 1,
                      ),
                    ],
                  ),
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
      ),
    );
  }
}

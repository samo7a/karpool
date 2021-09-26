import 'dart:ui';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile_app/models/RiderTrip.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/ModalButton.dart';

//TODO: add no. of seats left, car info (car make, color, maybe year)
class DriverModal extends StatefulWidget {
  const DriverModal({
    Key? key,
    // required this.profilePic,
    // required this.fullName,
    // required this.starRating,
    // required this.date,
    // required this.time,
    // required this.estimatedPrice,
    required this.showButtons,
    required this.trip,
    required this.driverId,
  }) : super(key: key);

  // final String profilePic;
  // final String fullName;
  // final int starRating; //change to double later
  // final String date;
  // final double estimatedPrice;
  // final String time;
  final bool showButtons;
  final RiderTrip trip;
  final String driverId;

  @override
  _DriverModalState createState() => _DriverModalState();
}

class _DriverModalState extends State<DriverModal> {
  // ignore: avoid_init_to_null
  late User driver = User(
    uid: "",
    firstName: "",
    lastName: "",
    isDriver: true,
    isRider: true,
    isVerified: true,
    rating: 0,
    profileURL: "https://wallpapercave.com/wp/wp7632684.jpg",
    phoneNumber: "",
  );
  late String driverId;
  late RiderTrip trip;
  late bool showButtons;
  void initState() {
    super.initState();
    driverId = widget.driverId;
    trip = widget.trip;
    getDriverInfo();
    showButtons = widget.showButtons;
  }

  void getDriverInfo() async {
    User d = await User.getDriverFromFireBase(driverId);
    setState(() {
      driver = d;
    });
  }

  void schedule() async {
    //TODO: call the endpoint function to schedule a ride
  }

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(size.BLOCK_WIDTH * 5),
        child: Material(
          color: Color(0xff0353A4),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(size.BLOCK_WIDTH * 3),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: size.BLOCK_HEIGHT * 3,
                    ),
                    Center(
                      child: Container(
                        width: size.BLOCK_WIDTH * 32,
                        height: size.BLOCK_HEIGHT * 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              driver.profileURL,
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
                            driver.firstName + " " + driver.lastName,
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
                        rating: driver.rating,
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
                          widget.trip.date,
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
                          widget.trip.time,
                          style: TextStyle(
                            color: kWhite,
                            fontFamily: 'Glory',
                            fontWeight: FontWeight.bold,
                            fontSize: size.FONT_SIZE * 20,
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: size.BLOCK_HEIGHT * 1,
                    // ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Icon(
                    //       Icons.location_searching,
                    //       color: Colors.green[800],
                    //     ),
                    //     SizedBox(
                    //       width: size.BLOCK_WIDTH * 3,
                    //     ),
                    //     Expanded(
                    //       child: Text(
                    //         widget.trip.fromAddress,
                    //         maxLines: 10,
                    //         overflow: TextOverflow.ellipsis,
                    //         softWrap: false,
                    //         style: TextStyle(
                    //           color: kWhite,
                    //           fontFamily: 'Glory',
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: size.FONT_SIZE * 20,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: size.BLOCK_WIDTH * 0.1),
                    //   child: Icon(
                    //     Icons.arrow_downward,
                    //     size: size.BLOCK_HEIGHT * 3,
                    //   ),
                    // ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Icon(
                    //       Icons.pin_drop_outlined,
                    //       color: Colors.red,
                    //     ),
                    //     SizedBox(
                    //       width: size.BLOCK_WIDTH * 3,
                    //     ),
                    //     Expanded(
                    //       child: Text(
                    //         widget.trip.toAddress,
                    //         maxLines: 10,
                    //         overflow: TextOverflow.ellipsis,
                    //         softWrap: false,
                    //         style: TextStyle(
                    //           color: kWhite,
                    //           fontFamily: 'Glory',
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: size.FONT_SIZE * 20,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    //     SizedBox(
                    //       height: size.BLOCK_HEIGHT * 1,
                    //     ),
                    //   ],
                    // ),
                    Center(
                      child: Text(
                        '\$ ' + widget.trip.estimatedPrice.toString(),
                        style: TextStyle(
                          color: Colors.green[400],
                          fontFamily: 'Glory',
                          fontWeight: FontWeight.bold,
                          fontSize: size.FONT_SIZE * 20,
                        ),
                      ),
                    ),
                    showButtons
                        ? Padding(
                            padding: EdgeInsets.all(size.BLOCK_WIDTH * 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ModalButton(
                                  buttonName: "Cancel",
                                  onClick: () {
                                    Navigator.pop(context);
                                  },
                                  color: 0xffF31818,
                                ),
                                ModalButton(
                                  buttonName: "Schedule",
                                  color: 0xff3CB032,
                                  onClick: schedule,
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile_app/models/RiderTrip.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/ModalButton.dart';
import 'package:provider/provider.dart';

//TODO: add no. of seats left, car info (car make, color, maybe year)
class RiderModal extends StatefulWidget {
  const RiderModal({
    Key? key,
    // required this.profilePic,
    // required this.fullName,
    // required this.starRating,
    // required this.date,
    // required this.time,
    // required this.estimatedPrice,
    // required this.trip,
    required this.riderid,
    required this.status,
    required this.tripid,
  }) : super(key: key);

  // final String profilePic;
  // final String fullName;
  // final int starRating; //change to double later
  // final String date;
  // final double estimatedPrice;
  // final String time;
  // final RiderTrip trip;
  final String riderid;
  final String? status;
  final String tripid;

  @override
  _RiderModalState createState() => _RiderModalState();
}

class _RiderModalState extends State<RiderModal> {
  late final user = Provider.of<User>(context, listen: false);
  String? status;
  late String riderid;
  late String tripid;
  // ignore: avoid_init_to_null
  User rider = User(
    uid: "",
    firstName: "",
    lastName: "",
    isDriver: true,
    isRider: true,
    isVerified: true,
    rating: 0,
    profileURL: "",
    phoneNumber: "",
    email: "",
  );
  void initState() {
    super.initState();
    riderid = widget.riderid;
    status = widget.status;
    tripid = widget.tripid;
    // trip = widget.trip;
    getRiderInfo();
  }

  void getRiderInfo() async {
    User r = await User.getRiderFromFireBase(riderid);
    setState(() {
      rider = r;
    });
  }

  void accept() async {
    EasyLoading.show(status: "Accepting the rider ...");
    HttpsCallable accept = FirebaseFunctions.instance.httpsCallable("trip-acceptRiderRequest");
    Map<String, String> obj = {
      "tripID": tripid,
      "riderID": riderid,
    };
    try {
      await accept(obj);
      EasyLoading.dismiss();
      Navigator.pop(context);
      EasyLoading.showSuccess("Rider joined!");
    } catch (e) {
      EasyLoading.dismiss();
      print(e.toString());
      EasyLoading.showError("Error Accepting the rider!");
    }
  }

  void decline() async {
    EasyLoading.show(status: "Declining the rider ...");
    HttpsCallable decline = FirebaseFunctions.instance.httpsCallable("trip-declineRiderRequest");
    Map<String, String> obj = {
      "tripID": tripid,
      "riderID": riderid,
      "driverID": user.uid,
    };
    try {
      await decline(obj);
      EasyLoading.dismiss();
      Navigator.pop(context);
      EasyLoading.showSuccess("Rider declined!");
    } catch (e) {
      EasyLoading.dismiss();
      print(e.toString());
      EasyLoading.showError("Error declining the rider!");
    }
  }

  void remove() async {
    EasyLoading.show(status: "Removing the rider from your trip ...");
    HttpsCallable remove = FirebaseFunctions.instance.httpsCallable("trip-cancelRiderbyDriver");
    Map<String, String> obj = {
      "tripID": tripid,
      "riderID": riderid,
      "driverID": user.uid,
    };
    try {
      await remove(obj);
      EasyLoading.dismiss();
      Navigator.pop(context);
      EasyLoading.showSuccess("Rider removed!");
    } catch (e) {
      EasyLoading.dismiss();
      print(e.toString());
      EasyLoading.showError("Error removing the rider!");
    }
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
                            image: rider.profileURL.isEmpty
                                ? AssetImage("images/chris.jpg") as ImageProvider
                                : NetworkImage(
                                    rider.profileURL,
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
                            rider.firstName + " " + rider.lastName,
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
                        rating: rider.rating,
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

                    SizedBox(
                      height: size.BLOCK_HEIGHT * 1,
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
                    Padding(
                      padding: EdgeInsets.all(size.BLOCK_WIDTH * 10),
                      child: status == "Requested"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ModalButton(
                                  buttonName: "Decline",
                                  onClick: decline,
                                  color: 0xffF31818,
                                ),
                                ModalButton(
                                  buttonName: "Accept",
                                  color: 0xff3CB032,
                                  onClick: accept,
                                ),
                              ],
                            )
                          : status == "Accepted"
                              ? ModalButton(
                                  buttonName: "Remove",
                                  onClick: remove,
                                  color: 0xffF31818,
                                )
                              : Container(),
                    ),
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

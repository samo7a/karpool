import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile_app/models/DriverTrip.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/screens/driver/DriverDashboardScreen.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';

class DriverRatingScreen extends StatefulWidget {
  const DriverRatingScreen({Key? key}) : super(key: key);
  static const String id = 'driverRatingScreen';
  @override
  _DriverRatingScreenState createState() => _DriverRatingScreenState();
}

class _DriverRatingScreenState extends State<DriverRatingScreen> {
  late final trip = ModalRoute.of(context)!.settings.arguments as DriverTrip;
  List<User> riders = [];
  late Size size = Size(Context: context);
  // final DriverTrip trip = DriverTrip(
  //   tripId: "tripId",
  //   date: "date",
  //   time: "time",
  //   fromAddress: "fromAddress",
  //   toAddress: "toAddress",
  //   estimatedPrice: 99,
  //   driverId: "driverId",
  //   isOpen: false,
  //   polyLine: "polyLine",
  //   seatNumbers: 2,
  //   estimatedDistance: 3,
  //   estimatedDuration: 3,
  //   estimatedFare: 3,
  //   riders: [],
  //   timestamp: "timestamp",
  //   ts: "ts",
  //   ridersInfo: [
  //     {"riderID": "jkWHPS6lzSdXxhb4zvezZAvb7Cl2"},
  //     {"riderID": "zjcPmQQeysMrDLvdYTCoLRXOWJo1"},
  //   ],
  //   startPoint: {},
  //   endPoint: {},
  // );

  Future<void> getRiders() async {
    for (int i = 0; i < trip.ridersInfo.length; i++) {
      User rider = await User.getRiderFromFireBase(trip.ridersInfo[i]["riderID"]);
      setState(() {
        riders.add(rider);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getRiders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rate The Rides"),
        centerTitle: true,
        backgroundColor: kDashboardColor,
        elevation: 0,
      ),
      body: Container(
        color: kDashboardColor,
        child: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                thickness: 2,
              );
            },
            itemCount: riders.length,
            itemBuilder: (BuildContext context, int index) {
              User rider = riders[index];
              double rating = 0;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.BLOCK_WIDTH * 5,
                      ),
                      CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(rider.getProfileURL),
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(
                        width: size.BLOCK_WIDTH * 5,
                      ),
                      Text(
                        rider.getFirstName + " " + rider.lastName,
                        style: TextStyle(
                          color: kWhite,
                          fontSize: size.FONT_SIZE * 15,
                        ),
                      ),
                      SizedBox(
                        width: size.BLOCK_WIDTH * 5,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red),
                        ),
                        onPressed: () async {
                          HttpsCallable rate =
                              FirebaseFunctions.instance.httpsCallable("trip-addDriverTripRating");
                          try {
                            EasyLoading.show(status: "");
                            await rate({
                              "tripID": trip.tripId,
                              "rating": -1,
                              "riderID": rider.getUid,
                            });

                            setState(() {
                              riders.removeAt(index);
                            });
                            EasyLoading.dismiss();
                            if (riders.length == 0)
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                DriverDashboardScreen.id,
                                (route) => false,
                              );
                          } catch (e) {
                            print(e);
                            EasyLoading.dismiss();
                            EasyLoading.showError("Error occured, please try again!");
                          }
                        },
                        child: Text("Skip"),
                      ),
                      SizedBox(
                        width: size.BLOCK_WIDTH * 5,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.BLOCK_WIDTH * 7,
                      ),
                      RatingBar(
                        maxRating: 5,
                        allowHalfRating: true,
                        initialRating: 0,
                        ratingWidget: RatingWidget(
                          empty: Icon(
                            Icons.star_border,
                            color: kStarsColor,
                          ),
                          half: Icon(
                            Icons.star_half,
                            color: kStarsColor,
                          ),
                          full: Icon(
                            Icons.star,
                            color: kStarsColor,
                          ),
                        ),
                        onRatingUpdate: (value) {
                          rating = value;
                          print(rating);
                        },
                      ),
                      SizedBox(
                        width: size.BLOCK_WIDTH * 5,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.green),
                        ),
                        onPressed: () async {
                          HttpsCallable rate =
                              FirebaseFunctions.instance.httpsCallable("trip-addDriverTripRating");
                          try {
                            EasyLoading.show(status: "Rating ...");
                            await rate({
                              "tripID": trip.tripId,
                              "rating": rating,
                              "riderID": rider.getUid,
                            });

                            setState(() {
                              riders.removeAt(index);
                            });
                            EasyLoading.dismiss();
                            if (riders.length == 0)
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                DriverDashboardScreen.id,
                                (route) => false,
                              );
                          } catch (e) {
                            print(e);
                            EasyLoading.dismiss();
                            EasyLoading.showError("Error occured, please try again!");
                          }
                        },
                        child: Text("Rate"),
                      ),
                      SizedBox(
                        width: size.BLOCK_WIDTH * 5,
                      ),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}

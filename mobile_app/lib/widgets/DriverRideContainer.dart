// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/DriverTrip.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/util/HeroDialog.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/RiderModal.dart';

class DriverRideContainer extends StatefulWidget {
  const DriverRideContainer({
    Key? key,
    // required this.date,
    // required this.time,
    // required this.fromAddress,
    // required this.toAddress,
    // required this.profilePic,
    // required this.estimatedPrice,
    // required this.status,
    required this.trip,
    // required this.onPress,
  }) : super(key: key);

  // final String date;
  // final String time;
  // final String fromAddress;
  // final String toAddress;
  // final String profilePic;
  // final String estimatedPrice;
  // final String status;
  final DriverTrip trip;

  @override
  State<DriverRideContainer> createState() => _DriverRideContainerState();
}

class _DriverRideContainerState extends State<DriverRideContainer> {
  List<User> riders = [];
  late final DriverTrip trip;

  @override
  void initState() {
    super.initState();
    trip = widget.trip;
    getRiders();
  }

  void getRiders() async {
    // final String? uid = trip.riders[0]["uid"];
    // final user = await User.getRiderFromFireBase(uid!);
    // riders.add(user);
    List<User> u = [];
    for (var rider in trip.riders) {
      String uid = rider["uid"] ?? "";
      String status = rider["status"] ?? "";
      if (status == "Rejected") continue;
      final user = await User.getRiderFromFireBase(uid);
      u.add(user);
    }
    print("lenght of the array: should be 2: " + u.length.toString());
    setState(() {
      riders = u;
    });
  }

  void showRiderModal(int index) {
    Navigator.of(context).push(
      HeroDialogRoute(
        builder: (context) {
          return RiderModal(
            // trip: trip,
            riderid: riders[index].uid,
            status: trip.riders[index]["status"],
            tripid: trip.tripId,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = new Size(Context: context);
    return Padding(
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                          // trip.fromAddress,
                          widget.trip.fromAddress,
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
                          widget.trip.toAddress,
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
              SizedBox(
                height: size.BLOCK_HEIGHT * 1,
              ),
              SizedBox(
                width: size.BLOCK_WIDTH * 78,
                height: size.BLOCK_HEIGHT * 10,
                child: ListView.separated(
                  padding: EdgeInsets.only(left: size.BLOCK_WIDTH * 4.6),
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: size.BLOCK_WIDTH * 4.6,
                    );
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: riders.length,
                  itemBuilder: (BuildContext context, int index) {
                    final rider = riders[index];
                    return GestureDetector(
                      onTap: () => showRiderModal(index),
                      child: Container(
                        width: size.BLOCK_WIDTH * 10,
                        height: size.BLOCK_HEIGHT * 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(rider.profileURL),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: Text(
                  '\$ ' + widget.trip.estimatedPrice.toString(),
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
    );
  }
}

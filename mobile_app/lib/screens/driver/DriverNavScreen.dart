// ignore_for_file: unused_field

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:location/location.dart';
import 'package:mobile_app/models/DriverTrip.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/screens/driver/DriverDashboardScreen.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/library.dart';

class DriverNavScreen extends StatefulWidget {
  static const String id = 'driverNavigationScreen';

  @override
  _DriverNavScreenState createState() => _DriverNavScreenState();
}

class _DriverNavScreenState extends State<DriverNavScreen> {
  late final trip = ModalRoute.of(context)!.settings.arguments as DriverTrip;
  late Size size = Size(Context: context);
  List<User> riders = [];
  final database = FirebaseDatabase.instance.reference();
  late final tripFromRealTimeDb = database.child("/trips/${trip.tripId}");
  bool rideStarted = false;
  String title = "Trip Summary";
  final location = Location();
  // String tripID = "";
  // String title = 'Trip Summary';
  // String role = 'Rider';
  // String profileURL = 'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg';
  // String name = 'Hussein Noureddine';
  // String from = '1000 S Semoran Blvd winter park , fl';
  // String to = '41000 S Semoran Blvd winter park , fl slslkdj  lskd djjjd  dkkd\n kdkdkdk';
  // String moneyTitle = 'Profit';
  // double money = 10.5;
  // double rating = 4.5;
  late MapBoxNavigationViewController _controller;
  late MapBoxOptions _options = MapBoxOptions(
    initialLatitude: trip.startPoint["latitude"],
    initialLongitude: trip.startPoint["longitude"],
    zoom: 15.0,
    tilt: 0.0,
    bearing: 0.0,
    enableRefresh: false,
    alternatives: true,
    voiceInstructionsEnabled: true,
    bannerInstructionsEnabled: true,
    allowsUTurnAtWayPoints: true,
    mode: MapBoxNavigationMode.driving,
    units: VoiceUnits.imperial,
    simulateRoute: true,
    animateBuildRoute: true,
    longPressDestinationEnabled: true,
    language: "en",
  );
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _isMultipleStop = false;
  double _distanceRemaining = 0;
  double _durationRemaining = 0;
  String _platformVersion = 'Unknown';
  String _instruction = "";
  late MapBoxNavigation _directions;
  
  void listenToLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    try {
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          Navigator.pop(context);
        }
      }
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print("error location denied: " + e.toString());
    }

    location.enableBackgroundMode(enable: false);

    location.onLocationChanged.listen((LocationData currentLocation) async {
      _locationData = currentLocation;
      double? lat = _locationData.latitude;
      double? long = _locationData.longitude;
      double? heading = _locationData.heading;
      await tripFromRealTimeDb.set({"lat": lat, "long": long, "heading": heading});
    });

    _locationData = await location.getLocation();
  }

  @override
  void dispose() {
    super.dispose();
    _directions.finishNavigation();
  }

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
    WidgetsBinding.instance!.addPostFrameCallback((_) => getRiders());
    _directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);
    initialize();
    listenToLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff33415C),
      appBar: AppBar(
        backgroundColor: Color(0xff33415C),
        title: Text(title),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          !rideStarted
              ? Column(
                  children: [
                    SizedBox(
                      height: size.BLOCK_HEIGHT * 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.BLOCK_WIDTH * 2,
                        ),
                        Icon(
                          Icons.pin_drop,
                          color: Colors.green[700],
                          size: size.FONT_SIZE * 25,
                        ),
                        SizedBox(
                          width: size.BLOCK_WIDTH * 2,
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
                    SizedBox(
                      height: size.BLOCK_HEIGHT * 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.BLOCK_WIDTH * 2,
                        ),
                        Icon(
                          Icons.pin_drop_outlined,
                          color: Colors.red[700],
                          size: size.FONT_SIZE * 25,
                        ),
                        SizedBox(
                          width: size.BLOCK_WIDTH * 2,
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
                      height: size.BLOCK_HEIGHT * 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.BLOCK_WIDTH * 2,
                        ),
                        Icon(
                          Icons.sports_score_sharp,
                          color: kWhite,
                          size: size.FONT_SIZE * 25,
                        ),
                        SizedBox(
                          width: size.BLOCK_WIDTH * 2,
                        ),
                        Center(
                          child: Text(
                            (riders.length * 2).toString() + " stops",
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
                      height: size.BLOCK_HEIGHT * 2,
                    ),
                    Center(
                      child: Text(
                        '\$ ' + trip.estimatedPrice.toString(),
                        style: TextStyle(
                          color: Colors.green[700],
                          fontFamily: 'Glory',
                          fontWeight: FontWeight.bold,
                          fontSize: size.FONT_SIZE * 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.BLOCK_HEIGHT * 2,
                    ),
                  ],
                )
              : Container(),
          !rideStarted
              ? ElevatedButton(
                  child: Text("Start the Ride"),
                  onPressed: () async {
                    EasyLoading.show(status: "Starting the ride ...");
                    HttpsCallable startRide =
                        FirebaseFunctions.instance.httpsCallable("trip-createScheduledTrip");
                    try {
                      await startRide({"tripID": trip.tripId});
                      print(trip.ridersInfo.toString() + " howa fih aa??");
                      print("start Multi stop");
                      List ridersInfo = trip.ridersInfo;
                      final origin = WayPoint(
                        name: trip.fromAddress,
                        latitude: trip.startPoint["latitude"],
                        longitude: trip.startPoint["longitude"],
                      );
                      final destination = WayPoint(
                        name: trip.toAddress,
                        latitude: trip.endPoint["latitude"],
                        longitude: trip.endPoint["longitude"],
                      );
                      _isMultipleStop = true;

                      var wayPoints = <WayPoint>[];
                      wayPoints.add(origin);

                      ridersInfo.sort((a, b) {
                        var pickA = a["pickupIndex"];
                        var pickB = b["pickupIndex"];
                        return pickA.compareTo(pickB);
                      });
                      print(ridersInfo);
                      for (int i = 0; i < ridersInfo.length; i++) {
                        String riderId = ridersInfo[i]["riderID"];
                        print("rider id inside the for loop " + riderId);
                        User u = await User.getRiderFromFireBase(riderId);
                        print(trip.riders[i][riderId]);

                        wayPoints.add(
                          WayPoint(
                            name: "${u.firstName} ${u.lastName}",
                            latitude: ridersInfo[i]["pickupLocation"]["latitude"],
                            longitude: ridersInfo[i]["pickupLocation"]["longitude"],
                          ),
                        );
                      }
                      ridersInfo.sort((a, b) {
                        var pickA = a["dropoffIndex"];
                        var pickB = b["dropoffIndex"];
                        return pickA.compareTo(pickB);
                      });
                      print(ridersInfo);
                      for (int i = 0; i < ridersInfo.length; i++) {
                        String riderId = ridersInfo[i]["riderID"];

                        User u = await User.getRiderFromFireBase(riderId);

                        wayPoints.add(
                          WayPoint(
                            name: "${u.firstName} ${u.lastName}",
                            latitude: ridersInfo[i]["dropoffLocation"]["latitude"],
                            longitude: ridersInfo[i]["dropoffLocation"]["longitude"],
                          ),
                        );
                      }
                      wayPoints.add(destination);
                      print(destination);
                      print(wayPoints);
                      _directions.startNavigation(
                        wayPoints: wayPoints,
                        options: MapBoxOptions(
                          mode: MapBoxNavigationMode.driving,
                          simulateRoute: true,
                          language: "en",
                          allowsUTurnAtWayPoints: true,
                          units: VoiceUnits.imperial,
                        ),
                      );
                      EasyLoading.dismiss();
                      setState(() {
                        rideStarted = true;
                        title = "Rate the Riders";
                      });
                    } catch (e) {
                      print(e);
                      EasyLoading.dismiss();
                    }
                  },
                )
              : Container(),
          rideStarted
              ? Expanded(
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
                                    backgroundColor:
                                        MaterialStateColor.resolveWith((states) => Colors.red),
                                  ),
                                  onPressed: () async {
                                    HttpsCallable rate = FirebaseFunctions.instance
                                        .httpsCallable("trip-addDriverTripRating");
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
                                    backgroundColor:
                                        MaterialStateColor.resolveWith((states) => Colors.green),
                                  ),
                                  onPressed: () async {
                                    HttpsCallable rate = FirebaseFunctions.instance
                                        .httpsCallable("trip-addDriverTripRating");
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
                )
              : Container(),
        ],
      ),
    );
  }

  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);
    _options = MapBoxOptions(
      // initialLatitude: trip.startPoint["latitude"],
      // initialLongitude: trip.startPoint["longitude"],
      zoom: 15.0,
      tilt: 0.0,
      bearing: 0.0,
      enableRefresh: false,
      alternatives: true,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      allowsUTurnAtWayPoints: true,
      mode: MapBoxNavigationMode.driving,
      units: VoiceUnits.imperial,
      simulateRoute: true,
      animateBuildRoute: true,
      longPressDestinationEnabled: true,
      language: "en",
    );

    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await _directions.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await _directions.distanceRemaining;
    _durationRemaining = await _directions.durationRemaining;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null)
          _instruction = progressEvent.currentStepInstruction!;
        break;
      case MapBoxEvent.route_building:
        break;
      case MapBoxEvent.route_built:
        _routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        _routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        _isNavigating = true;
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
        break;
      case MapBoxEvent.navigation_cancelled:
        _routeBuilt = false;
        _isNavigating = false;
        break;
      default:
        break;
    }
  }
}

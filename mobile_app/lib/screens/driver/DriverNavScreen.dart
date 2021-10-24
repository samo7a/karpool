import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/DriverTrip.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/screens/driver/DriverDashboardScreen.dart';
import 'package:mobile_app/screens/driver/DriverRatingScreen.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/widgets/SlidePanel.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/library.dart';

class DriverNavScreen extends StatefulWidget {
  static const String id = 'driverNavigationScreen';

  @override
  _DriverNavScreenState createState() => _DriverNavScreenState();
}

class _DriverNavScreenState extends State<DriverNavScreen> {
  final database = FirebaseDatabase.instance.reference();
  late final tripFromRealTimeDb = database.child("/trips/${trip.tripId}");
  late final trip = ModalRoute.of(context)!.settings.arguments as DriverTrip;
  late Size size = Size(Context: context);
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

  @override
  void dispose() {
    super.dispose();
    _directions.finishNavigation();
  }

  @override
  void initState() {
    super.initState();
    print("initState");
    _directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff33415C),
      appBar: AppBar(
        backgroundColor: Color(0xff33415C),
        title: Text("Trip Navigation"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // MapBoxNavigationView(
          //   options: _options,
          //   onRouteEvent: _onEmbeddedRouteEvent,
          //   onCreated: (MapBoxNavigationViewController controller) async {
          //     _controller = controller;
          //     controller.initialize();
          //   },
          // ),
          ElevatedButton(
            child: Text("Start Multi Stop"),
            onPressed: () async {
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

                  // if (trip.riders[i][riderId] == "Accepted")
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

                  // if (trip.riders[i][riderId] == "Accepted")
                  wayPoints.add(
                    WayPoint(
                      name: "${u.firstName} ${u.lastName}",
                      latitude: ridersInfo[i]["pickupLocation"]["latitude"],
                      longitude: ridersInfo[i]["pickupLocation"]["longitude"],
                    ),
                  );
                }
                wayPoints.add(destination);
                print(destination);
                print(wayPoints);
                await _directions.startNavigation(
                  wayPoints: wayPoints,
                  options: MapBoxOptions(
                    mode: MapBoxNavigationMode.driving,
                    simulateRoute: true,
                    language: "en",
                    allowsUTurnAtWayPoints: true,
                    units: VoiceUnits.imperial,
                  ),
                );
                print("push ya m3lm");
                // tripFromRealTimeDb.set({"lat": -22, "long": 22});
                Timer(
                  Duration(seconds: 1),
                  () async => await Navigator.pushNamed(
                    context,
                    DriverRatingScreen.id,
                    arguments: trip,
                  ),
                );
                //await Navigator.pushNamed(context, DriverDashboardScreen.id);
              } catch (e) {
                print(e);
              }
            },
          ),
          // SlidePanel(
          //   title: title,
          //   role: role,
          //   profileURL: profileURL,
          //   money: money,
          //   rating: rating,
          //   source: from,
          //   destination: to,
          //   fullname: name,
          //   moneyTitle: moneyTitle,
          // ),
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

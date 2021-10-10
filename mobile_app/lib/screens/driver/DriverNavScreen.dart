import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/widgets/SlidePanel.dart';
import 'package:location/location.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/library.dart';

class DriverNavScreen extends StatefulWidget {
  static const String id = 'driverNavigationScreen';

  @override
  _DriverNavScreenState createState() => _DriverNavScreenState();
}

class _DriverNavScreenState extends State<DriverNavScreen> {
  String title = 'Trip Summary';
  String role = 'Rider';
  String profileURL = 'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg';
  String name = 'Hussein Noureddine';
  String from = '1000 S Semoran Blvd winter park , fl';
  String to = '41000 S Semoran Blvd winter park , fl slslkdj  lskd djjjd  dkkd\n kdkdkdk';
  String moneyTitle = 'Profit';
  double money = 10.5;
  double rating = 4.5;
  late MapBoxNavigationViewController _controller;
  MapBoxOptions _options = MapBoxOptions(
    initialLatitude: 36.1175275,
    initialLongitude: -115.1839524,
    zoom: 15.0,
    tilt: 0.0,
    bearing: 0.0,
    enableRefresh: false,
    alternatives: true,
    voiceInstructionsEnabled: true,
    bannerInstructionsEnabled: true,
    allowsUTurnAtWayPoints: true,
    mode: MapBoxNavigationMode.drivingWithTraffic,
    units: VoiceUnits.imperial,
    simulateRoute: false,
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

  final _origin = WayPoint(name: "Way Point 1", latitude: 28.58185308, longitude: -81.30832491);
  final _stop1 = WayPoint(name: "Way Point 2", latitude: 28.488359, longitude: -81.429638);
  final _stop2 = WayPoint(name: "Way Point 3", latitude: 28.468275, longitude: -81.452194);
  final _stop3 = WayPoint(name: "Way Point 4", latitude: 25.796395, longitude: -80.277177);
  final _stop4 = WayPoint(name: "Way Point 5", latitude: 25.492905, longitude: -80.421999);
  final _destination = WayPoint(name: "Way Point 5", latitude: 25.318357, longitude: -80.280417);

  @override
  void initState() {
    super.initState();
    _directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
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
          MapBoxNavigationView(
            options: _options,
            onRouteEvent: _onEmbeddedRouteEvent,
            onCreated: (MapBoxNavigationViewController controller) async {
              _controller = controller;
              controller.initialize();
            },
          ),
          ElevatedButton(
            child: Text("Start Multi Stop"),
            onPressed: () async {
              _isMultipleStop = true;
              var wayPoints = <WayPoint>[];
              wayPoints.add(_origin);
              wayPoints.add(_stop1);
              wayPoints.add(_stop2);
              wayPoints.add(_stop3);
              wayPoints.add(_stop4);
              wayPoints.add(_destination);

              await _directions.startNavigation(
                wayPoints: wayPoints,
                options: MapBoxOptions(
                    mode: MapBoxNavigationMode.drivingWithTraffic,
                    simulateRoute: false,
                    language: "en",
                    allowsUTurnAtWayPoints: true,
                    units: VoiceUnits.imperial),
              );
            },
          ),
          SlidePanel(
            title: title,
            role: role,
            profileURL: profileURL,
            money: money,
            rating: rating,
            source: from,
            destination: to,
            fullname: name,
            moneyTitle: moneyTitle,
          ),
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
      // initialLatitude: 36.1175275,
      // initialLongitude: -115.1839524,
      zoom: 15.0,
      tilt: 0.0,
      bearing: 0.0,
      enableRefresh: false,
      alternatives: true,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      allowsUTurnAtWayPoints: true,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      units: VoiceUnits.imperial,
      simulateRoute: false,
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
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }
}

import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile_app/models/RiderTrip.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/screens/rider/RiderDashboardScreen.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/widgets/SlidePanel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class RiderNavScreen extends StatefulWidget {
  static const String id = 'riderNavigationScreen';

  @override
  _RiderNavScreenState createState() => _RiderNavScreenState();
}

class _RiderNavScreenState extends State<RiderNavScreen> {
  late User user = Provider.of<User>(context, listen: false);
  late final RiderTrip trip;
  final database = FirebaseDatabase.instance.reference();
  late final tripFromRealTimeDb = database.child("/trips/${trip.tripId}");

  String title = 'Trip Summary';
  String role = 'Driver';
  String profileURL = 'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg';
  String name = 'Hussein Noureddine';
  String from = '123 Sesame Street';
  String to = '456 UCF Street';
  String moneyTitle = 'Fee';
  double money = 10.5;
  double rating = 4.5;

  double driverRating = 0;

  bool isRideEnded = false;
  double currentLat = 0;
  double currentLong = 0;
  double driverLat = 0;
  double driverLong = 0;
  double driverHeading = 0;

  Location location = new Location();
  GoogleMapController? mapController;
  List<PointLatLng> polyline = [];
  Uint8List? imageData;
  late User driver;

  void getDriver() async {
    User d = await User.getDriverFromFireBase(trip.driverId);
    setState(() {
      name = d.firstName + ' ' + d.lastName;
      profileURL = d.profileURL;
      from = trip.fromAddress;
      to = trip.toAddress;
      money = trip.estimatedFare;
      driver = d;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

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
      if (mounted) {
        setState(() {
          currentLat = _locationData.latitude!;
          currentLong = _locationData.longitude!;
        });
      }
    });

    _locationData = await location.getLocation();
  }

  static final CameraPosition _initialLocation = CameraPosition(
    target: LatLng(42.601154885399914, -99.99501138934635),
    zoom: 3.5,
    tilt: 30,
  );

  void getDriverLocation() async {
    await tripFromRealTimeDb.onValue.listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          driverLat = snapshot.value['lat'] * 1.0;
          driverLong = snapshot.value['long'] * 1.0;
          driverHeading = snapshot.value['heading'] * 1.0;
        });
      }
    });
  }

  late String poly;

  @override
  void initState() {
    super.initState();
    listenToLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    trip = ModalRoute.of(context)!.settings.arguments as RiderTrip;
    poly = trip.polyLine;
    polyline = PolylinePoints().decodePolyline(poly);
    getDriver();
    getDriverLocation();
  }

  @override
  void dispose() {
    super.dispose();
    mapController!.dispose();
    location.enableBackgroundMode(enable: false);
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load('images/car.png');
    return byteData.buffer.asUint8List();
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    Uint8List u = await getMarker();
    setState(() {
      imageData = u;
    });
  }

  Marker _createMarker() {
    if (imageData != null) {
      return Marker(
        rotation: driverHeading,
        markerId: MarkerId("marker_1"),
        position: LatLng(driverLat, driverLong), //driver position
        flat: true,
        draggable: false,
        zIndex: 2,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData!),
      );
    } else {
      return Marker(
        rotation: driverHeading, // driver heading
        markerId: MarkerId("marker_1"),
        position: LatLng(28.5, -81.3), //driver position
      );
    }
  }

  double degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  double getDistanceBetweenPoints(double lat1, double lon1, double lat2, double lon2) {
    var R = 6378137; // Radius of the earth in m
    var dLat = degreesToRadians(lat2 - lat1); // deg2rad below
    var dLon = degreesToRadians(lon2 - lon1);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(degreesToRadians(lat1)) *
            math.cos(degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var d = R * c; // Distance in m
    return d;
  }

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    _createMarkerImageFromAsset(context);
    return Scaffold(
      backgroundColor: Color(0xff33415C),
      appBar: AppBar(
        backgroundColor: Color(0xff33415C),
        title: isRideEnded ? Text("Rate the driver") : Text("Trip Navigation"),
        centerTitle: true,
        elevation: 0,
      ),
      body: isRideEnded
          ? Column(
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
                      backgroundImage: NetworkImage(driver.getProfileURL),
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(
                      width: size.BLOCK_WIDTH * 5,
                    ),
                    Text(
                      driver.getFirstName + " " + driver.lastName,
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
                            FirebaseFunctions.instance.httpsCallable("trip-addRiderTripRating");
                        try {
                          EasyLoading.show(status: "");
                          await rate({
                            "tripID": trip.tripId,
                            "rating": -1.0,
                            "riderID": user.uid,
                            "driverID": trip.driverId,
                          });

                          EasyLoading.dismiss();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RiderDashboardScreen.id,
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
                        setState(() {
                          driverRating = value;
                        });

                        print(driverRating);
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
                            FirebaseFunctions.instance.httpsCallable("trip-addRiderTripRating");
                        try {
                          EasyLoading.show(status: "Rating ...");
                          await rate({
                            "tripID": trip.tripId,
                            "rating": driverRating * 1.0,
                            "riderID": user.uid,
                            "driverID": trip.driverId,
                          });
                          EasyLoading.dismiss();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RiderDashboardScreen.id,
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
            )
          : Stack(
              children: [
                Container(
                  height: size.BLOCK_HEIGHT * 70,
                  width: double.infinity,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    compassEnabled: true,
                    initialCameraPosition: _initialLocation,
                    zoomControlsEnabled: false,
                    tiltGesturesEnabled: false,
                    rotateGesturesEnabled: true,
                    markers: Set<Marker>.of(
                      [
                        _createMarker(),
                        Marker(
                          markerId: MarkerId('1'),
                          position: LatLng(
                            trip.startPoint["latitude"] ?? 0.0,
                            trip.startPoint["longitude"] ?? 0.0,
                          ),
                          infoWindow: InfoWindow(
                            title: "Pickup",
                            snippet: trip.fromAddress,
                          ),
                        ),
                        Marker(
                          markerId: MarkerId('2'),
                          position: LatLng(
                            trip.endPoint["latitude"] ?? 0.0,
                            trip.endPoint["longitude"] ?? 0.0,
                          ),
                          infoWindow: InfoWindow(
                            title: "Dropoff",
                            snippet: trip.toAddress,
                          ),
                        ),
                      ],
                    ),
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId("polyId"),
                        color: Colors.blue,
                        width: 5,
                        points: polyline.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                      )
                    },
                    onMapCreated: _onMapCreated,
                  ),
                ),
                Positioned(
                  bottom: size.BLOCK_HEIGHT * 10,
                  right: size.BLOCK_WIDTH * 25,
                  left: size.BLOCK_WIDTH * 25,
                  child: ElevatedButton(
                    onPressed: () async {
                      var distance = getDistanceBetweenPoints(currentLat, currentLong,
                          trip.endPoint["latitude"] ?? 0.0, trip.endPoint["longitude"] ?? 0.0);
                      if (distance > 50) {
                        // > 50 meters
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("You are too far from the destination"),
                          ),
                        );
                        return;
                      }
                      setState(() {
                        isRideEnded = true;
                      });
                    },
                    child: Text(
                      "End Ride",
                    ),
                  ),
                ),
                SlidePanel(
                  title: title,
                  role: role,
                  profileURL: profileURL,
                  fullname: name,
                  rating: rating,
                  source: from,
                  destination: to,
                  money: money,
                  moneyTitle: moneyTitle,
                ),
              ],
            ),
    );
  }
}

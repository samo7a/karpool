// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:flutter/material.dart';
// import 'package:mobile_app/util/constants.dart';
// // import 'package:mobile_app/util/Size.dart';
// import 'package:mobile_app/widgets/SlidePanel.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class RiderNavScreen extends StatefulWidget {
//   static const String id = 'riderNavigationScreen';

//   @override
//   _RiderNavScreenState createState() => _RiderNavScreenState();
// }

// class _RiderNavScreenState extends State<RiderNavScreen> {
//   String title = 'Trip Summary';
//   String role = 'Driver';
//   String profileURL =
//       'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg';
//   String name = 'Hussein Noureddine';
//   String from = '123 Sesame Street';
//   String to = '456 UCF Street';
//   String moneyTitle = 'Fee';
//   double money = 10.5;
//   double rating = 4.5;

//   double currentLat = 0;
//   double currentLong = 0;
//   Location location = new Location();
//   GoogleMapController? mapController;
//   List<PointLatLng> result = [];

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   void listenToLocation() async {
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;
//     LocationData _locationData;
//     _serviceEnabled = await location.serviceEnabled();
//     try {
//       if (!_serviceEnabled) {
//         _serviceEnabled = await location.requestService();
//         if (!_serviceEnabled) {
//           Navigator.pop(context);
//         }
//       }
//       _permissionGranted = await location.hasPermission();
//       if (_permissionGranted == PermissionStatus.denied) {
//         _permissionGranted = await location.requestPermission();
//         if (_permissionGranted != PermissionStatus.granted) {
//           Navigator.pop(context);
//         }
//       }
//     } catch (e) {
//       print("error location denied: " + e.toString());
//     }

//     location.enableBackgroundMode(enable: true);

//     location.onLocationChanged.listen((LocationData currentLocation) {
//       _locationData = currentLocation;

//       mapController!.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             bearing: 270.0,
//             target: LatLng(_locationData.latitude!, _locationData.longitude!),
//             tilt: 30.0,
//             zoom: 15.5,
//           ),
//         ),
//       );
//     });

//     _locationData = await location.getLocation();
//   }

//   static final CameraPosition _initialLocation = CameraPosition(
//     target: LatLng(42.601154885399914, -99.99501138934635),
//     zoom: 4,
//   );

//   CameraPosition currentLocation = CameraPosition(
//     bearing: 192.8334901395799,
//     target: LatLng(0, 0),
//     zoom: 14.4746,
//   );

//   String poly =
//       r"oz}mDjduoNLEPBLNNCj@ANYTGFCTLBLBX^d@ZWTI~@Eb@GbBOb@AE_BCcAA{E?aJAyECeEC{B@qBCaE?{D?aGFeBH_AT_B`@kBZgAXiAJ{@DgAAeGAsCCkMCaHAiEF_ED{FB_HE}KC}AMoDSaEGaEAmLDyAP}A\_Bd@oAl@mAd@o@f@i@vAsAb@m@v@sArBsErB{ExE{KdD_IpAeCd@s@^m@fDuEfEyF`LkO~FyHxDiFhDiELe@Ra@p@}@d@i@tBqCxA_CvCeE|@cA^[x@aAZq@Pk@Fg@Dg@?{BAyBJyIByD@gECkL@}FAgFEsUGgSKoPE_ZIsWWea@[yd@OaUCuIAgLA}FC}D@wB?{@CqI?{E@gGCsK@sE?oG@iJIiNWqX[mb@CyJ@kE?qDWkC[yA}@mC{@yAs@}@cB}Am@_@aBo@iBa@gAOqACkE@eB?}AM_AOk@Q}@_@u@a@eAu@u@w@_@e@o@gAo@}Ag@mBOcAQgCCiJ?sTDqHTgIV_GVmEf@kFb@gFDk@WQu@s@aBoAk@[yB_Ac@OeAYoAU}AOKFWAgBC}CBa@Bg@MyEBkCD_@JsHF{GHAEGC_CAmC@qBCwBSiAc@k@Uc@Wy@k@oAoASISY_@{@q@mB]cBMqAEqABsF?}BkHBw@?AwEAOKMg@?EF?nB";
  
//   @override
//   void initState() {
//     super.initState();
//     listenToLocation();
//     result = PolylinePoints().decodePolyline(poly);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Size size = Size(Context: context);
//     return Scaffold(
//       backgroundColor: Color(0xff33415C),
//       appBar: AppBar(
//         backgroundColor: Color(0xff33415C),
//         title: Text("Trip Navigation"),
//         centerTitle: true,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: kWhite,
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             mapType: MapType.normal,
//             myLocationButtonEnabled: true,
//             myLocationEnabled: true,
//             initialCameraPosition: _initialLocation,
//             zoomControlsEnabled: false,
//             polylines: {
//               Polyline(
//                 polylineId: const PolylineId("polyId"),
//                 color: Colors.blue,
//                 width: 5,
//                 points:
//                     result.map((e) => LatLng(e.latitude, e.longitude)).toList(),
//               )
//             },
//             onMapCreated: _onMapCreated,
//           ),
//           SlidePanel(
//             title: title,
//             role: role,
//             profileURL: profileURL,
//             money: money,
//             rating: rating,
//             source: from,
//             destination: to,
//             fullname: name,
//             moneyTitle: moneyTitle,
//           ),
//         ],
//       ),
//     );
//   }
// }

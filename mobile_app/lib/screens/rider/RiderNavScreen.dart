import 'package:flutter/material.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/widgets/SlidePanel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RiderNavScreen extends StatefulWidget {
  static const String id = 'driverNavigationScreen';

  @override
  _RiderNavScreenState createState() => _RiderNavScreenState();
}

class _RiderNavScreenState extends State<RiderNavScreen> {
  String title = 'Trip Summary';
  String role = 'Driver';
  String profileURL =
      'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg';
  String name = 'Hussein Noureddine';
  String from = '123 Sesame Street';
  String to = '456 UCF Street';
  String moneyTitle = 'Fee';
  double money = 10.5;
  double rating = 4.5;

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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: kWhite,
          ),
        ),
      ),
      body: SlidePanel(
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
    );
  }
}

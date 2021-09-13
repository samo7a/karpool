import 'package:flutter/material.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/util/constants.dart';

class SearchRidesScreen extends StatefulWidget {
  static const String id = 'searchRidesScreen';
  const SearchRidesScreen({ Key? key }) : super(key: key);

  @override
  _SearchRidesScreenState createState() => _SearchRidesScreenState();
}

class _SearchRidesScreenState extends State<SearchRidesScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return Scaffold(
      backgroundColor: kDashboardColor,
      appBar: AppBar(
        backgroundColor: kDashboardColor,
        title: Text(
          'Search for a ride',
          style: TextStyle(
            fontSize: size.FONT_SIZE * 24,
            color: kWhite,
            fontFamily: 'Glory',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: kWhite,
          ),
        ),
        elevation: 0.0,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RiderHistoryScreen extends StatefulWidget {
  const RiderHistoryScreen({Key? key}) : super(key: key);

  @override
  _RiderHistoryScreenState createState() => _RiderHistoryScreenState();
}

class _RiderHistoryScreenState extends State<RiderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff33415C),
      child: Center(
        child: Text(
          'Rider History Screen',
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RiderHistoryScreen extends StatefulWidget {
  static const id = 'riderHistoryScreen';
  const RiderHistoryScreen({Key? key}) : super(key: key);

  @override
  _RiderHistoryScreenState createState() => _RiderHistoryScreenState();
}

class _RiderHistoryScreenState extends State<RiderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            'Rider History',
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_app/util/constants.dart';

class TabHandler extends StatelessWidget {
  const TabHandler({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kButtonColor,
      child: TabBar(
        labelColor: kWhite,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: EdgeInsets.all(10.0),
        indicatorColor: kBlue,
        tabs: [
          Tab(
            text: 'Home',
            icon: Icon(Icons.home)
          ),
          Tab(
            text: 'History',
            icon: Icon(Icons.history),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/screens/EditProfileScreen.dart';
import 'package:mobile_app/screens/MainScreen.dart';
import 'package:mobile_app/screens/driver/DriverDashboardScreen.dart';
import 'package:mobile_app/screens/rider/DriverApplication.dart';
import 'package:mobile_app/screens/rider/PaymentScreen.dart';
import 'package:mobile_app/util/Auth.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:provider/provider.dart';
import 'TopDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RiderDrawer extends StatefulWidget {
  const RiderDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _RiderDrawerState createState() => _RiderDrawerState();
}

class _RiderDrawerState extends State<RiderDrawer> {
  late bool isDriver; 

  @override
  void initState() {
    super.initState();
    getCurrentRole();
  }

  void getCurrentRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDriver = prefs.getString("role") == "driver" ? true : false;
    });
  }

  toggleSwitch(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("role", "driver");
    setState(() {
      isDriver = !isDriver;
    });
    return new Timer(new Duration(seconds: 1), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        DriverDashboardScreen.id,
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);
    Size size = Size(Context: context);
    return Drawer(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: size.BLOCK_HEIGHT * 45,
            child: TopDrawer(),
          ),
          Container(
            height: size.BLOCK_HEIGHT * 3,
            color: kDrawerColor,
          ),
          user.isDriver && user.isRider
              ? Container(
                  color: kDrawerColor,
                  child: FlutterSwitch(
                    height: size.BLOCK_HEIGHT * 6,
                    width: size.BLOCK_WIDTH * 26,
                    toggleSize: 35.0,
                    value: isDriver,
                    borderRadius: 30.0,
                    showOnOff: true,
                    activeText: 'Driver',
                    inactiveText: 'Rider',
                    inactiveTextColor: Color(0xFF0466CB),
                    padding: 2.0,
                    activeToggleColor: Color(0xFF0582ff),
                    inactiveToggleColor: Color(0xFF0466CB),
                    activeSwitchBorder: Border.all(
                      color: Color(0xFF0466CB),
                      width: 6.0,
                    ),
                    inactiveSwitchBorder: Border.all(
                      color: Color(0xFFD1D5DA),
                      width: 6.0,
                    ),
                    activeColor: Color(0xFF00439c),
                    inactiveColor: Colors.white,
                    activeIcon: Icon(
                      Icons.directions_car,
                      color: kWhite,
                      size: 22,
                    ),
                    inactiveIcon: Icon(
                      Icons.hail,
                      color: kWhite,
                      size: 22,
                    ),
                    onToggle: (value) => toggleSwitch(value),
                  ),
                )
              : Container(
                  color: kDrawerColor,
                  child: ListTile(
                    title: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.carSide,
                          color: kWhite,
                          size: 38,
                        ),
                        SizedBox(width: 25),
                        Text(
                          'Drive With Kärpōōl',
                          style: TextStyle(
                            fontFamily: 'Glory',
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: kWhite,
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      return showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(size.BLOCK_WIDTH * 7),
                            ),
                            title: Text(
                              "Start Driver Application",
                              style: TextStyle(
                                color: Color(0xffffffff),
                              ),
                            ),
                            content: Text(
                              "Are you sure you want to become a driver?",
                              style: TextStyle(
                                color: Color(0xffffffff),
                                fontFamily: 'Glory',
                                fontWeight: FontWeight.bold,
                                fontSize: size.FONT_SIZE * 22,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Container(
                                  height: size.BLOCK_HEIGHT * 7,
                                  width: size.BLOCK_WIDTH * 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(size.BLOCK_WIDTH * 5),
                                    color: Color(0xff001233),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "No",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xffffffff),
                                        fontFamily: 'Glory',
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.FONT_SIZE * 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: size.BLOCK_WIDTH * 2.5),
                                child: TextButton(
                                  onPressed: () {
                                    //api call to add role as a rider to become a driver
                                    //push to driverapplication
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DriverApplication(),
                                        settings: RouteSettings(
                                          arguments: user,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: size.BLOCK_HEIGHT * 7,
                                    width: size.BLOCK_WIDTH * 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(size.BLOCK_WIDTH * 5),
                                      color: Color(0xff3CB032),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Yes",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xffffffff),
                                          fontFamily: 'Glory',
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.FONT_SIZE * 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            backgroundColor: Color(0xff0353A4),
                          );
                        },
                        barrierDismissible: true,
                      );
                    },
                  ),
                ),
          //end of flutter switch
          Container(
            height: 8,
            color: kDrawerColor,
          ),
          Container(
            color: kDrawerColor,
            child: ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    color: kWhite,
                    size: 38,
                  ),
                  SizedBox(width: 25),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontFamily: 'Glory',
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: kWhite,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  EditProfilScreen.id,
                );
              },
            ),
          ),
          Container(
            height: 8,
            color: kDrawerColor,
          ),
          Container(
            color: kDrawerColor,
            child: ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.credit_card_outlined,
                    color: kWhite,
                    size: 38,
                  ),
                  SizedBox(width: 25),
                  Text(
                    'Payment Setup',
                    style: TextStyle(
                      fontFamily: 'Glory',
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: kWhite,
                    ),
                  ),
                ],
              ),
              onTap: () {
                // remove user, add card, Card model under construction
                Navigator.pushNamed(
                  context,
                  PaymentScreen.id,
                );
              },
            ),
          ),
          Container(
            height: 8,
            color: kDrawerColor,
          ),
          Container(
            color: kDrawerColor,
            child: ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: kWhite,
                    size: 38,
                  ),
                  SizedBox(width: 25),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'Glory',
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: kWhite,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                await context.read<Auth>().signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ),
          Container(
            height: 8,
            color: kDrawerColor,
          ),
          Container(
            color: kDrawerColor,
            child: ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                    size: 38,
                  ),
                  SizedBox(width: 25),
                  Text(
                    'Delete Account',
                    style: TextStyle(
                      fontFamily: 'Glory',
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                return showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.BLOCK_WIDTH * 7),
                      ),
                      title: Text(
                        "Delete Confirmation",
                        style: TextStyle(
                          color: Color(0xffffffff),
                        ),
                      ),
                      content: Text(
                        "Are you sure you want to delete your account?",
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontFamily: 'Glory',
                          fontWeight: FontWeight.bold,
                          fontSize: size.FONT_SIZE * 22,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Container(
                            height: size.BLOCK_HEIGHT * 7,
                            width: size.BLOCK_WIDTH * 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(size.BLOCK_WIDTH * 5),
                              color: Color(0xff001233),
                            ),
                            child: Center(
                              child: Text(
                                "No",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontFamily: 'Glory',
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.FONT_SIZE * 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: size.BLOCK_WIDTH * 2.5),
                          child: TextButton(
                            onPressed: () {
                              //api call to delete account
                            },
                            child: Container(
                              height: size.BLOCK_HEIGHT * 7,
                              width: size.BLOCK_WIDTH * 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(size.BLOCK_WIDTH * 5),
                                color: Color(0xffC80404),
                              ),
                              child: Center(
                                child: Text(
                                  "Yes",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xffffffff),
                                    fontFamily: 'Glory',
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.FONT_SIZE * 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      backgroundColor: Color(0xff0353A4),
                    );
                  },
                  barrierDismissible: false,
                );
              },
            ),
          ),
          Container(
            height: 8,
            color: kDrawerColor,
          ),
          Column(
            children: [
              Container(
                color: kDrawerColor,
                height: size.BLOCK_HEIGHT * 25,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

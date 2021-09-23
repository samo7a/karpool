import 'package:flutter/material.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/screens/EditProfileScreen.dart';
import 'package:mobile_app/screens/MainScreen.dart';
import 'package:mobile_app/screens/rider/PaymentScreen.dart';
import 'package:mobile_app/util/Auth.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:provider/provider.dart';
import 'TopDrawer.dart';

class RiderDrawer extends StatelessWidget {
  const RiderDrawer({
    required this.user,
    Key? key,
  }) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    final int rating = user.rating; //change to double later
    final String uName = user.firstName + " " + user.lastName;
    final String imageLink = user.profileURL;
    Size size = Size(Context: context);
    return Drawer(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: size.BLOCK_HEIGHT * 45,
            child: TopDrawer(
              starRating: rating,
              fullName: uName,
              profilePic: imageLink,
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
                Navigator.pushNamed(context, EditProfilScreen.id, arguments: user);
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
                Navigator.pushNamed(context, PaymentScreen.id, arguments: user);
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
                  //fix the buttons here functions
                  //not final
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

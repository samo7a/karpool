import 'package:flutter/material.dart';
import 'package:mobile_app/models/User.dart';
import 'package:mobile_app/screens/EditProfileScreen.dart';
import 'package:mobile_app/screens/MainScreen.dart';
import 'package:mobile_app/util/Auth.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/util/Size.dart';
import 'package:mobile_app/widgets/ConfiramtionAlert.dart';
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
                    size: 40,
                  ),
                  SizedBox(width: 25),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontFamily: 'Glory',
                      fontSize: 25,
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
                    size: 40,
                  ),
                  SizedBox(width: 25),
                  Text(
                    'Payment Setup',
                    style: TextStyle(
                      fontFamily: 'Glory',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: kWhite,
                    ),
                  ),
                ],
              ),
              onTap: () {},
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
                    size: 40,
                  ),
                  SizedBox(width: 25),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'Glory',
                      fontSize: 25,
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
                    size: 40,
                  ),
                  SizedBox(width: 25),
                  Text(
                    'Delete Account',
                    style: TextStyle(
                      fontFamily: 'Glory',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  //fix the buttons here functions
                  //not final
                  builder: (_) => ConfirmationAlert(
                    title: "You are about to delete your account!",
                    msg: "Are you sure you want to delete your account?",
                    textColor: 0xffffff,
                    backgroundColor: 0x000000,
                    rightButtonText: "Yes, delete my account",
                    leftButtonText: "No, take me back",
                    leftButtonColor: 0x933933,
                    rightButtonColor: 0x1919191,
                    rightButtonAction: () =>
                        print("delete function"), //TODO: call the firebase delete function
                    leftButtonAction: () => Navigator.pop(context),
                  ),
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

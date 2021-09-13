import 'package:flutter/material.dart';
// import 'package:mobile_app/util/constants.dart';

class ConfirmationAlert extends StatelessWidget {
  const ConfirmationAlert({
    Key? key,
    required this.backgroundColor,
    required this.leftButtonAction,
    required this.leftButtonColor,
    required this.leftButtonText,
    required this.msg,
    required this.rightButtonAction,
    required this.rightButtonColor,
    required this.rightButtonText,
    required this.textColor,
    required this.title,
  }) : super(key: key);
  final String title;
  final String msg;
  final Color backgroundColor;
  final Color textColor;
  final String rightButtonText;
  final String leftButtonText;
  final Color rightButtonColor;
  final Color leftButtonColor;
  final Function rightButtonAction;
  final Function leftButtonAction;
 
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "$title",
        style: TextStyle(
          color: textColor,
        ),
      ),
      content: Text(
        "$msg",
        style: TextStyle(
          color: textColor,
        ),
      ),
      actions: [
        TextButton(
          onPressed: leftButtonAction(),
          child: Text(
            "$leftButtonText",
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
        TextButton(
          onPressed: rightButtonAction(),
          child: Text(
            "$rightButtonText",
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ],
      backgroundColor: backgroundColor,
    );
  }
}

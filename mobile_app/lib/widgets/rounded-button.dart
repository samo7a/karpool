import 'package:flutter/material.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/util/Size.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.buttonName,
    required this.onClick,
  }) : super(key: key);

  final String buttonName;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    Size size = new Size(Context: context);
    return Padding(
      padding: EdgeInsets.all(size.BLOCK_HEIGHT * 2),
      child: Container(
        height: size.BLOCK_HEIGHT * 7,
        width: size.BLOCK_WIDTH * 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 16),
          color: kButtonColor,
        ),
        child: TextButton(
          onPressed: () {
            onClick();
          },
          child: Text(
            buttonName,
            style: TextStyle(fontSize: size.FONT_SIZE * 20, color: Colors.white, height: 1),
          ),
        ),
      ),
    );
  }
}

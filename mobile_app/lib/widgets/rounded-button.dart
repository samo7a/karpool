import 'package:flutter/material.dart';
import 'package:mobile_app/pallete.dart';
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
    return Container(
      height: size.BLOCK_HEIGHT * 10,
      width: size.BLOCK_WIDTH * 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: kBlue,
      ),
      child: TextButton(
        onPressed: () {
          onClick();
        },
        child: Text(
          buttonName,
          style: kBodyText.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

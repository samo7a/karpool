import 'package:flutter/material.dart';
import 'package:mobile_app/util/Size.dart';

class ModalButton extends StatelessWidget {
  const ModalButton({
    Key? key,
    required this.buttonName,
    required this.onClick,
    required this.color,
  }) : super(key: key);

  final String buttonName;
  final Function onClick;
  final int color;

  @override
  Widget build(BuildContext context) {
    Size size = new Size(Context: context);
    return Container(
      height: size.BLOCK_HEIGHT * 6,
      width: size.BLOCK_WIDTH * 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size.BLOCK_HEIGHT * 16),
        color: Color(color),
      ),
      child: TextButton(
        onPressed: () {
          onClick();
        },
        child: Text(
          buttonName,
          style: TextStyle(
            fontSize: size.FONT_SIZE * 15,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
    );
  }
}

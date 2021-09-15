import 'package:flutter/material.dart';
import 'package:mobile_app/util/constants.dart';
import '../util/Size.dart';

class TextInputField extends StatelessWidget {
  const TextInputField({
    Key? key,
    required this.icon,
    required this.hint,
    required this.inputType,
    required this.inputAction,
    required this.controller,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    Size size = new Size(Context: context);
    return Container(
      height: size.BLOCK_HEIGHT * 8,
      width: size.BLOCK_WIDTH * 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(size.BLOCK_WIDTH * 10),
      ),
      child: Center(
        child: TextFormField(
          
          maxLength: 50,
          controller: controller,
          decoration: InputDecoration(
            counterText: "",
            //contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            prefixIcon: Icon(
              icon,
              size: size.FONT_SIZE * 25,
              color: kWhite,
            ),
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: size.FONT_SIZE * 18,
              color: Colors.white,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
          keyboardType: inputType,
          textInputAction: inputAction,
        ),
      ),
    );
  }
}

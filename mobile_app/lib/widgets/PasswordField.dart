import 'package:flutter/material.dart';
import 'package:mobile_app/util/constants.dart';
import 'package:mobile_app/util/Size.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
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
    Size size = Size(Context: context);
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
            border: InputBorder.none,
            prefixIcon: Icon(
              icon,
              size: size.FONT_SIZE * 20,
              color: kWhite,
            ),
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: size.FONT_SIZE * 18,
              color: kWhite,
            ),
          ),
          obscureText: true,
          keyboardType: inputType,
          textInputAction: inputAction,
        ),
      ),
    );
  }
}

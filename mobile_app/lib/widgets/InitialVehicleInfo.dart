import 'package:mobile_app/util/Size.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/util/constants.dart';

class InitialVehicleInfo extends StatelessWidget {
  const InitialVehicleInfo({
    Key? key,
    required this.field,
  }) : super(key: key);

  final String field;

  @override
  Widget build(BuildContext context) {
    Size size = Size(Context: context);
    return Container(
      width: size.BLOCK_WIDTH * 100,
      height: size.BLOCK_HEIGHT * 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: kWhite.withOpacity(0.4),
      ),
      child: Center(
        child: Text(
          field,
          style: TextStyle(fontWeight: FontWeight.bold,
          fontSize: size.FONT_SIZE * 16),
        ),
      ),
    );
  }
}

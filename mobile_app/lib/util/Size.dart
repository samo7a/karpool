import 'package:flutter/material.dart';

class Size {
  MediaQueryData _mediaQueryData = new MediaQueryData();
  // ignore: non_constant_identifier_names
  double SCREEN_WIDTH = 0;
  // ignore: non_constant_identifier_names
  double SCREEN_HEIGHT = 0;
  // ignore: non_constant_identifier_names
  double FONT_SIZE = 0;
  // ignore: non_constant_identifier_names
  double BLOCK_WIDTH = 0;
  // ignore: non_constant_identifier_names
  double BLOCK_HEIGHT = 0;
  double _safeAreaHorizontal = 0;
  double _safeAreaVertical = 0;
  // ignore: non_constant_identifier_names
  double SAFE_BLOCK_WIDTH = 0;
  // ignore: non_constant_identifier_names
  double SAFE_BLOCK_HEIGHT = 0;

  // ignore: non_constant_identifier_names
  Size({required BuildContext Context}) {
    _mediaQueryData = MediaQuery.of(Context);
    SCREEN_WIDTH = _mediaQueryData.size.width;
    SCREEN_HEIGHT = _mediaQueryData.size.height;
    FONT_SIZE = _mediaQueryData.textScaleFactor;
    BLOCK_WIDTH = SCREEN_WIDTH / 100;
    BLOCK_HEIGHT = SCREEN_HEIGHT / 100;

    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    SAFE_BLOCK_WIDTH = (SCREEN_WIDTH - _safeAreaHorizontal) / 100;
    SAFE_BLOCK_HEIGHT = (SCREEN_HEIGHT - _safeAreaVertical) / 100;
  }
}

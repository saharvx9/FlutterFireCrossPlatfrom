import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;
  static double safeIsMobile = 1.0;

  void init(BuildContext context) {
    safeIsMobile = kIsWeb ? 0.8 :1.0;
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width * safeIsMobile;
    screenHeight = _mediaQueryData.size.height * safeIsMobile;
    blockSizeHorizontal = screenWidth / 100 * safeIsMobile;
    blockSizeVertical = screenHeight / 100 * safeIsMobile;

    _safeAreaHorizontal = (_mediaQueryData.padding.left + _mediaQueryData.padding.right) * safeIsMobile;
    _safeAreaVertical = (_mediaQueryData.padding.top + _mediaQueryData.padding.bottom)* safeIsMobile;
    safeBlockHorizontal = ((screenWidth - _safeAreaHorizontal) / 100)* safeIsMobile;
    safeBlockVertical = ((screenHeight - _safeAreaVertical) / 100) * safeIsMobile;
  }

  static double get spacing_small_vertical => safeBlockVertical * 2 * safeIsMobile;

  static double get spacing_medium_vertical => safeBlockVertical * 3 * safeIsMobile;

  static double get spacing_normal_vertical => safeBlockVertical * 4 * safeIsMobile;

  static double get spacing_large_vertical => safeBlockVertical * 7 * safeIsMobile;

  static double get font_extra => safeBlockHorizontal * 7 * safeIsMobile;

  static double get font_large => safeBlockHorizontal * 6 * safeIsMobile;

  static double get font_medium => safeBlockHorizontal * 4.5 * safeIsMobile;

  static double get font_small => safeBlockHorizontal * 3.5 * safeIsMobile;

  static double get font_mini => safeBlockHorizontal * 2 * safeIsMobile;

  static double get font_main_screen => safeBlockHorizontal * 5 * safeIsMobile;


}

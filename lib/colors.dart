import 'package:flutter/material.dart';

//-----------------------------------------------------------------------------//

class RockusColors {
  static const Map<int, Color> _lightBlueBGColor = {
    50: Color.fromRGBO(0, 30, 28, .1),
    100: Color.fromRGBO(0, 30, 28, .2),
    200: Color.fromRGBO(0, 30, 28, .3),
    300: Color.fromRGBO(0, 30, 28, .4),
    400: Color.fromRGBO(0, 30, 28, .5),
    500: Color.fromRGBO(0, 30, 28, .6),
    600: Color.fromRGBO(0, 30, 28, .7),
    700: Color.fromRGBO(0, 30, 28, .8),
    800: Color.fromRGBO(0, 30, 28, .9),
    900: Color.fromRGBO(0, 30, 28, 1),
  };

//-----------------------------------------------------------------------------//

  static const Map<int, Color> _darkBlueBGColor = {
    50: Color.fromRGBO(30, 28, 50, .1),
    100: Color.fromRGBO(30, 28, 50, .2),
    200: Color.fromRGBO(30, 28, 50, .3),
    300: Color.fromRGBO(30, 28, 50, .4),
    400: Color.fromRGBO(30, 28, 50, .5),
    500: Color.fromRGBO(30, 28, 50, .6),
    600: Color.fromRGBO(30, 28, 50, .7),
    700: Color.fromRGBO(30, 28, 50, .8),
    800: Color.fromRGBO(30, 28, 50, .9),
    900: Color.fromRGBO(30, 28, 50, 1),
  };

//-----------------------------------------------------------------------------//

  static const MaterialColor lightBlueBGColor =
      MaterialColor(0xFF1E1C32, _lightBlueBGColor);

//-----------------------------------------------------------------------------//

  static const MaterialColor darkBlueBGColor =
      MaterialColor(0xFF0E0D18, _darkBlueBGColor);
}

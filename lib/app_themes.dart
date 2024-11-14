import 'package:flutter/material.dart';

class CustomTheme extends ThemeExtension<CustomTheme> {
  Brightness? brightness;
  Color? valueIncrease;
  Color? valueDecrease;

  CustomTheme({
    this.valueIncrease,
    this.valueDecrease,
  }) {
    valueDecrease = Colors.red;
    valueIncrease = Colors.green;
  }

  @override
  CustomTheme copyWith({
    Color? valueIncrease,
    Color? valueDecrease,
  }) {
    return CustomTheme(
      valueIncrease: valueIncrease ?? this.valueIncrease,
      valueDecrease: valueDecrease ?? this.valueDecrease,
    );
  }

  @override
  CustomTheme lerp(CustomTheme? other, double t) {
    if (other is! CustomTheme) {
      return this;
    }

    return CustomTheme(
      valueIncrease: Color.lerp(valueIncrease, other.valueIncrease, t),
      valueDecrease: Color.lerp(valueDecrease, other.valueDecrease, t),
    );
  }

  Color securityStatusColour(double securityStatus) {
    switch(securityStatus) {
      case 1.0:
        return const Color(0xFF2e74dc);
      case 0.9:
        return const Color(0xFF379cf7);
      case 0.8:
        return const Color(0xFF4acff0);
      case 0.7:
        return const Color(0xFF62daa6);
      case 0.6:
        return const Color(0xFF73e352);
      case 0.5:
        return const Color(0xFFeeff83);
      case 0.4:
        return const Color(0xFFdc6c09);
      case 0.3:
        return const Color(0xFFd1440d);
      case 0.2:
        return const Color(0xFFbc1114);
      case 0.1:
        return const Color(0xFF6d2028);
      default:
        return const Color(0xFF8f2f69);
    }
  }
}

ThemeData customTheme({Brightness? brightness}) {
  return ThemeData(
    brightness: brightness,
    extensions: <ThemeExtension<dynamic>>[
      CustomTheme(),
    ]
  );
}
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
}

ThemeData customTheme({Brightness? brightness}) {
  return ThemeData(
    brightness: brightness,
    extensions: <ThemeExtension<dynamic>>[
      CustomTheme(),
    ]
  );
}
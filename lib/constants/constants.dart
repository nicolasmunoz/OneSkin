import 'package:flutter/material.dart';

class Images {
  static Image logo = const Image(image: AssetImage('assets/small_logo.png'));
  static Image tutorial1 =
      const Image(image: AssetImage('assets/tutorial_1.png'));
  static Image tutorial2 =
      const Image(image: AssetImage('assets/tutorial_2.png'));
  static Image hipaa = const Image(image: AssetImage('assets/hipaa.png'));
  static Image largeLogo =
      const Image(image: AssetImage('assets/large_logo.png'));
  static Image homeHero =
      const Image(image: AssetImage('assets/home_hero.png'));
  static Icon diagnosisImage = const Icon(Icons.bar_chart_rounded);
  static Icon recommendationImage = const Icon(Icons.medical_services_rounded);
  static Icon doubleArrow = const Icon(Icons.mobile_screen_share_rounded);
}

class ThemeColors {
  static Color darkBackground = const Color(0xFF1e1f25);
}

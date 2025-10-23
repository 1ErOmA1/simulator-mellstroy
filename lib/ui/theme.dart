import 'package:flutter/material.dart';

const kAppBackground = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('assets/images/background.png'),
    fit: BoxFit.cover,
  ),
);

const kCardGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF8C3ED1),
    Color(0xFF6A2BE2),
  ],
);

final appColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF6F2DA8),
  brightness: Brightness.dark,
);

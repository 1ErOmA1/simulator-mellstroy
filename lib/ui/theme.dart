import 'package:flutter/material.dart';

const kAppGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF6F2DA8),
    Color(0xFF4A2B63),
    Color(0xFF2B1A3A),
  ],
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

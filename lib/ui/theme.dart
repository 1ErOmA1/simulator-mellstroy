import 'package:flutter/material.dart';

/// Возвращает BoxDecoration с фоном в зависимости от уровня игрока
BoxDecoration getBackgroundForLevel(int level) {
  String bgPath;

  if (level < 5) {
    bgPath = 'assets/backgrounds/room_1.png';
  } else if (level < 10) {
    bgPath = 'assets/backgrounds/room_2.png';
  } else if (level < 20) {
    bgPath = 'assets/backgrounds/room_3.png';
  } else {
    bgPath = 'assets/backgrounds/room_4.png';
  }

  return BoxDecoration(
    image: DecorationImage(
      image: AssetImage(bgPath),
      fit: BoxFit.cover,
    ),
  );
}

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

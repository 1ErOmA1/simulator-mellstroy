import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LevelCard extends StatelessWidget {
  final int level;
  final int xp;

  const LevelCard({
    super.key,
    required this.level,
    required this.xp,
  });

  // 🎖️ Названия уровней
  String _getLevelTitle(int level) {
    const titles = [
      "Новичок", "Любитель", "Стример-ученик", "В эфире!", "Первые фанаты",
      "Популярный", "Известный", "В трендах", "Мастер контента", "Профи",
      "Гуру трансляций", "Маг стримов", "Король эфира", "Легенда Twitch",
      "Мировая звезда", "Кибер-идол", "Сенсация сети", "Суперзвезда",
      "Икона контента", "Бессмертный стример",
      "Создатель эпохи", "Голос поколения", "Мастер медиа", "Повелитель контента",
      "Инфлюенсер", "Гений лайвов", "Бог стримов", "Царь зрителей",
      "Медиа-титан", "Галактический стример", "Властелин чата",
      "Император фоловеров", "Король лайков", "Номер один",
      "Мега-легенда", "Сверхразум", "Икона YouTube", "Феномен эфира",
      "Гений сцены", "Неостановимый", "Чемпион сети", "Создатель миров",
      "Хозяин алгоритма", "Вдохновитель", "Мастодонт контента",
      "Глобальная икона", "Создатель трендов", "Бессмертный креатор",
      "Непобедимый", "Вечный талант", "Кибер-бог", "Мастер эпохи",
      "Царь платформы", "Бессмертная звезда", "Эпохальный", "Создатель реальности",
      "Мифический", "Галактический", "Мета-человек", "Абсолютный стример",
      "Вселенский лидер", "Создатель вселенной", "Император контента",
      "Сверхбог лайвов", "Легенда легенд", "Светоч эпохи", "Создатель эпохи",
      "Владыка миров", "Неоспоримый", "Главный герой", "Феникс",
      "Архимастер", "Сверхикона", "Абсолютный лидер", "Титан", "Первозданный",
      "Гений будущего", "Оракул стримов", "Творец эпохи", "Король будущего",
      "Создатель всего", "Вечный дух", "Бессмертный", "Сознание сети",
      "Мета-существо", "Абсолют", "Финальный стример", "Бог эфира",
      "Создатель контента", "Мировой разум", "Истинная легенда",
      "Мастер вселенной", "Великий", "Совершенство", "Финал эпохи",
      "Вечная звезда", "Легенда", "Последний герой", "Небожитель", "Абсолютный мастер"
    ];

    if (level <= titles.length) return titles[level - 1];
    return "Легенда";
  }

  @override
  Widget build(BuildContext context) {
    final int maxXp = 100 * level;
    final double progress = (xp / maxXp).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF3B1F2A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, color: Color(0xFFFFD36A), size: 40),
          const SizedBox(height: 10),

          Text(
            'Уровень $level',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),

          const SizedBox(height: 6),

          // 🏅 звание
          Text(
            _getLevelTitle(level),
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 14),

          // 📊 плавный прогресс XP
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 500), // ⏱ скорость заполнения
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return Stack(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD36A), Color(0xFFF8A435)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 6),

          Text(
            '$xp / $maxXp XP',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

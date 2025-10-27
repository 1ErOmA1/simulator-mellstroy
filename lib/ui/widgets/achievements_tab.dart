import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/toast_manager.dart';

class Achievement {
  final String title;
  final String description;
  final String imagePath;
  final bool unlocked;

  const Achievement({
    required this.title,
    required this.description,
    required this.imagePath,
    this.unlocked = false,
  });

  Achievement copyWith({bool? unlocked}) {
    return Achievement(
      title: title,
      description: description,
      imagePath: imagePath,
      unlocked: unlocked ?? this.unlocked,
    );
  }
}

class AchievementsTab extends StatefulWidget {
  final int coins;
  final int gold;
  final int level;
  final int clicks;
  final int upgradesBought;

  const AchievementsTab({
    super.key,
    required this.coins,
    required this.gold,
    required this.level,
    this.clicks = 0,
    this.upgradesBought = 0,
  });

  @override
  State<AchievementsTab> createState() => _AchievementsTabState();
}

class _AchievementsTabState extends State<AchievementsTab> {
  late List<Achievement> achievements;

  @override
  void initState() {
    super.initState();
    achievements = [
      // 💰 Серебро
      const Achievement(
        title: "Первые 100 монет 🪙",
        description: "Заработай 100 серебряных монет",
        imagePath: "assets/images/silver_coin.png",
      ),
      const Achievement(
        title: "Серебряный мастер 💎",
        description: "Заработай 10,000 серебра",
        imagePath: "assets/images/silver_coin.png",
      ),
      const Achievement(
        title: "Серебряный миллиардер 🏦",
        description: "Заработай 1,000,000 серебра",
        imagePath: "assets/images/silver_coin.png",
      ),

      // 🟡 Золото
      const Achievement(
        title: "Золотой старт 🏅",
        description: "Получить 1 золотую монету",
        imagePath: "assets/images/gold_coin.png",
      ),
      const Achievement(
        title: "Золотой миллионер 👑",
        description: "Получить 10 золотых монет",
        imagePath: "assets/images/gold_coin.png",
      ),

      // 🧠 Уровень
      const Achievement(
        title: "Путь стримера 🚀",
        description: "Достигни 5 уровня популярности",
        imagePath: "assets/images/level_up.png",
      ),
      const Achievement(
        title: "Легенда эфира 🌟",
        description: "Достигни 20 уровня",
        imagePath: "assets/images/level_up.png",
      ),
      const Achievement(
        title: "Бессмертный стример 🔥",
        description: "Достигни 50 уровня",
        imagePath: "assets/images/level_up.png",
      ),

      // 🖱️ Клики
      const Achievement(
        title: "Первые шаги 👆",
        description: "Сделай 100 кликов",
        imagePath: "assets/images/tap_icon.png",
      ),
      const Achievement(
        title: "Фанат кликов ⚡",
        description: "Сделай 10,000 кликов",
        imagePath: "assets/images/tap_icon.png",
      ),
      const Achievement(
        title: "Царь кликов 💥",
        description: "Сделай 1,000,000 кликов",
        imagePath: "assets/images/tap_icon.png",
      ),

      // 🧩 Улучшения
      const Achievement(
        title: "Первое улучшение 🔧",
        description: "Купи одно улучшение",
        imagePath: "assets/images/upgrade_icon.png",
      ),
      const Achievement(
        title: "Инженер успеха ⚙️",
        description: "Купи 10 улучшений",
        imagePath: "assets/images/upgrade_icon.png",
      ),
      const Achievement(
        title: "Гений апгрейдов 🧠",
        description: "Купи 100 улучшений",
        imagePath: "assets/images/upgrade_icon.png",
      ),

      // 🌍 Особое
      const Achievement(
        title: "Ветеран стримов 🎥",
        description: "Проведи тысячи эфиров и не сдайся!",
        imagePath: "assets/images/stream_icon.png",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAchievements(context);
    });

    return achievements.isEmpty
        ? Center(
            child: Text(
              'Ачивки пока недоступны 🥇',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final a = achievements[index];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color:
                      a.unlocked ? Colors.green.withOpacity(0.1) : Colors.white10,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: a.unlocked ? Colors.greenAccent : Colors.white24,
                    width: 1,
                  ),
                  boxShadow: a.unlocked
                      ? [
                          BoxShadow(
                            color: Colors.greenAccent.withOpacity(0.25),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  children: [
                    Image.asset(
                      a.imagePath,
                      width: 36,
                      height: 36,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.emoji_events,
                        color: Colors.white54,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.title,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            a.description,
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      a.unlocked ? Icons.check_circle : Icons.lock,
                      color:
                          a.unlocked ? Colors.greenAccent : Colors.white24,
                    ),
                  ],
                ),
              );
            },
          );
  }

  void _checkAchievements(BuildContext context) {
    for (int i = 0; i < achievements.length; i++) {
      final a = achievements[i];
      if (!a.unlocked) {
        final c = widget.coins;
        final g = widget.gold;
        final l = widget.level;
        final clicks = widget.clicks;
        final upgrades = widget.upgradesBought;

        if (a.title.contains("100 монет") && c >= 100) {
          _unlock(i, context);
        } else if (a.title.contains("мастер") && c >= 10000) {
          _unlock(i, context);
        } else if (a.title.contains("миллиардер") && c >= 1000000) {
          _unlock(i, context);
        } else if (a.title.contains("Золотой старт") && g >= 1) {
          _unlock(i, context);
        } else if (a.title.contains("миллионер") && g >= 10) {
          _unlock(i, context);
        } else if (a.title.contains("стримера") && l >= 5) {
          _unlock(i, context);
        } else if (a.title.contains("Легенда") && l >= 20) {
          _unlock(i, context);
        } else if (a.title.contains("Бессмертный") && l >= 50) {
          _unlock(i, context);
        } else if (a.title.contains("Первые шаги") && clicks >= 100) {
          _unlock(i, context);
        } else if (a.title.contains("Фанат кликов") && clicks >= 10000) {
          _unlock(i, context);
        } else if (a.title.contains("Царь кликов") && clicks >= 1000000) {
          _unlock(i, context);
        } else if (a.title.contains("Первое улучшение") && upgrades >= 1) {
          _unlock(i, context);
        } else if (a.title.contains("Инженер") && upgrades >= 10) {
          _unlock(i, context);
        } else if (a.title.contains("Гений") && upgrades >= 100) {
          _unlock(i, context);
        } else if (a.title.contains("Ветеран") && (clicks >= 100000 && l >= 30)) {
          _unlock(i, context);
        }
      }
    }
  }

  void _unlock(int i, BuildContext context) {
    setState(() {
      achievements[i] = achievements[i].copyWith(unlocked: true);
    });

    ToastManager().showToast(
      context,
      '🎉 Новое достижение: ${achievements[i].title}',
      icon: Icons.emoji_events_rounded,
      color: Colors.greenAccent,
    );
  }
}

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

  const AchievementsTab({
    super.key,
    required this.coins,
    required this.gold,
    required this.level,
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
      Achievement(
        title: "Первые 100 монет 🪙",
        description: "Заработай 100 серебряных монет",
        imagePath: "assets/images/silver_coin.png",
      ),
      Achievement(
        title: "Золотой старт 🏅",
        description: "Получить 1 золотую монету",
        imagePath: "assets/images/gold_coin.png",
      ),
      Achievement(
        title: "Путь стримера 🚀",
        description: "Достигни 5 уровня популярности",
        imagePath: "assets/images/level_up.png",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _checkAchievements(context);

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
              return Container(
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
                ),
                child: Row(
                  children: [
                    Image.asset(
                      a.imagePath,
                      width: 36,
                      height: 36,
                      errorBuilder: (context, _, __) => const Icon(
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
        if (a.title.contains("100 монет") && widget.coins >= 100) {
          _unlockAchievement(i, context);
        } else if (a.title.contains("Золотой") && widget.gold >= 1) {
          _unlockAchievement(i, context);
        } else if (a.title.contains("стримера") && widget.level >= 5) {
          _unlockAchievement(i, context);
        }
      }
    }
  }

  void _unlockAchievement(int index, BuildContext context) {
  setState(() {
    achievements[index] = achievements[index].copyWith(unlocked: true);
  });

  // 🔇 ToastManager временно отключён:
  // ToastManager().showToast(
  //   context,
  //   '🎉 Новое достижение: ${achievements[index].title}',
  //   icon: Icons.emoji_events_rounded,
  //   color: Colors.greenAccent,
  // );

  debugPrint('🎉 Новое достижение: ${achievements[index].title}');
}

}

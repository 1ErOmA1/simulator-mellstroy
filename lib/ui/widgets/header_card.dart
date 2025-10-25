import 'dart:math'; // ⚙️ для pow()
import 'package:flutter/material.dart';
import '../theme.dart';
import 'stats_row.dart';

class HeaderCard extends StatefulWidget {
  final double views;
  final int subs;
  final double money;
  final double income;
  final int xp;
  final int level;
  final VoidCallback onAvatarTap;

  const HeaderCard({
    super.key,
    required this.views,
    required this.subs,
    required this.money,
    required this.income,
    required this.xp,
    required this.level,
    required this.onAvatarTap,
  });

  @override
  State<HeaderCard> createState() => _HeaderCardState();
}

class _HeaderCardState extends State<HeaderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  /// 📈 Требуемый XP для перехода на следующий уровень (как в mell_home.dart)
  int requiredXpForLevel(int currentLevel) {
    if (currentLevel <= 1) return 100;
    final double base = 1000.0; // XP для перехода 1 → 2
    final double value = base * pow(1.05, (currentLevel - 2));
    return value.round();
  }

  @override
  Widget build(BuildContext context) {
    final int maxXp = requiredXpForLevel(widget.level);
    final double progress = (widget.xp / maxXp).clamp(0.0, 1.0);

    final bool levelUp = progress >= 1.0;

    if (levelUp) {
      _glowController.repeat(reverse: true);
    } else {
      _glowController.stop();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.02),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            GestureDetector(
              onTap: widget.onAvatarTap,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: levelUp
                              ? [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.8),
                                    blurRadius: _glowAnimation.value,
                                    spreadRadius: _glowAnimation.value / 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: child,
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 72,
                          height: 72,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 6,
                            backgroundColor: Colors.white.withOpacity(0.08),
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xFFFFC857),
                            ),
                          ),
                        ),
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white.withOpacity(0.12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            'assets/images/icon.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  // 🏅 Текущий уровень
                  Text(
                    'Уровень ${widget.level}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            // 📊 Статистика справа
            Expanded(
              child: StatsRow(
                views: widget.views,
                subs: widget.subs,
                money: widget.money,
                income: widget.income,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

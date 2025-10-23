import 'package:flutter/material.dart';
import '../theme.dart';
import 'stats_row.dart';

class HeaderCard extends StatelessWidget {
  final double views;
  final int subs;
  final double money;
  final double income;
  final int xp;
  final int level;
  final VoidCallback onAvatarTap; // 👈 добавлен колбэк

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
  Widget build(BuildContext context) {
    final int maxXp = 10 * level;
    final double progress = xp / maxXp;

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
            // 👇 аватарка с XP-прогрессом
            GestureDetector(
              onTap: onAvatarTap,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      strokeWidth: 6,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      valueColor:
                          const AlwaysStoppedAnimation(Color(0xFFFFC857)),
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

            const SizedBox(width: 12),

            // 📊 Статистика
            Expanded(
              child: StatsRow(
                views: views,
                subs: subs,
                money: money,
                income: income,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

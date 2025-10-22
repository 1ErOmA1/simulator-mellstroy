import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'upgrades_tab.dart';
import 'achievements_tab.dart';

class BottomTabs extends StatefulWidget {
  const BottomTabs({super.key});

  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  double money = 200.0;
  double clickBonus = 1.0;
  double passiveBonus = 0.0;

  void changeMoney(double delta) {
    setState(() => money += delta);
  }

  void applyUpgrade(double click, double passive) {
    setState(() {
      clickBonus += click;
      passiveBonus += passive;
    });
  }

  // --- Универсальная функция открытия модального окна ---
  void _openFullScreen(String title, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 1, // занимает весь экран
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF2B1A3A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // --- Индикатор свайпа вниз ---
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 10),

                // --- Верхняя панель с крестиком ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1, color: Colors.white10),

                // --- Контент с анимацией появления ---
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.05),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Баланс: ${money.toStringAsFixed(1)} ₽',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _tabButton("Улучшения", Icons.upgrade, () {
                  _openFullScreen(
                    "Улучшения",
                    UpgradesTab(
                      money: money,
                      onMoneyChange: changeMoney,
                      onUpgrade: applyUpgrade,
                    ),
                  );
                }),
                _tabButton("Достижения", Icons.emoji_events_outlined, () {
                  _openFullScreen("Достижения", const AchievementsTab());
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

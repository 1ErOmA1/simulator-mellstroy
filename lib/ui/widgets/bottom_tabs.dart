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
  int selectedIndex = 0;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Баланс: ${money.toStringAsFixed(1)} ₽',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _tabButton("Улучшения", 0),
              _tabButton("Достижения", 1),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: selectedIndex == 0
              ? UpgradesTab(
                  key: const ValueKey('upgrades'),
                  money: money,
                  onMoneyChange: changeMoney,
                  onUpgrade: applyUpgrade,
                )
              : const AchievementsTab(key: ValueKey('achievements')),
        ),
      ],
    );
  }

  Widget _tabButton(String text, int index) {
    final bool isActive = selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

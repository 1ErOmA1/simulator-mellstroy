import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'upgrades_tab.dart';
import 'achievements_tab.dart';
import 'shop_tab.dart';

class BottomTabs extends StatefulWidget {
  final double silver;
  final Function(double) onSilverChange;
  final Function(double, double) onUpgrade;

  final List<Map<String, dynamic>> upgrades;
  final Function(int) onBuyUpgrade;

  const BottomTabs({
    super.key,
    required this.silver,
    required this.onSilverChange,
    required this.onUpgrade,
    required this.upgrades,
    required this.onBuyUpgrade,
  });

  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
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
          heightFactor: 0.92,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF2B1A3A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 10),
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
                Expanded(child: child),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool showIcons = screenWidth > 456;

    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _tabButton("Улучшения", Icons.upgrade, showIcons, () {
                _openFullScreen(
                  "Улучшения",
                  StatefulBuilder(
                    builder: (context, setModalState) {
                      return UpgradesTab(
                        views: widget.silver,
                        upgrades: widget.upgrades,
                        onBuyUpgrade: (index) {
                          widget.onBuyUpgrade(index);
                          setModalState(() {}); // 🔄 обновляем UI вкладки
                        },
                      );
                    },
                  ),
                );
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _tabButton(
                "Достижения",
                Icons.emoji_events_outlined,
                showIcons,
                () {
                  _openFullScreen(
                    "Достижения",
                    AchievementsTab(
                      coins: widget.silver.toInt(),
                      gold: 0,
                      level: 1,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _tabButton(
                "Магазин",
                Icons.shopping_cart_outlined,
                showIcons,
                () {
                  _openFullScreen(
                    "Магазин",
                    ShopTab(
                      onGoldChange: (gold) {
                        print("Получено $gold золота");
                      },
                      onIncomeMultiplier: (multiplier) {
                        print("x$multiplier доход активен");
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(
      String text, IconData icon, bool showIcon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showIcon) ...[
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

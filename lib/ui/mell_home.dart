import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'widgets/header_card.dart';
import 'widgets/level_card.dart';
import 'widgets/stream_image.dart';
import 'widgets/bottom_tabs.dart';
import 'theme.dart';

class MellHome extends StatefulWidget {
  const MellHome({super.key});

  @override
  State<MellHome> createState() => _MellHomeState();
}

class _MellHomeState extends State<MellHome>
    with SingleTickerProviderStateMixin {
  int views = 0;
  int subs = 0;
  double silver = 0; // 💰 серебро
  double income = 0;
  int xp = 0;
  int level = 1;
  bool _showLevelCard = false;
  Timer? _timer;

  late AnimationController _cardController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _startIncomeTimer();

    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutBack,
    );
  }

  void _startIncomeTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        silver += income;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cardController.dispose();
    super.dispose();
  }

  // 👇 исправляем систему XP и уровня
  void _onStreamTap() {
    setState(() {
      views += 1;
      xp += 1; // 1 XP за клик

      int earnedSubs = views ~/ 100;
      int earnedSilver = views ~/ 100;

      if (earnedSubs > subs) {
        subs = earnedSubs;
        silver += (earnedSilver - silver.floor()).toDouble();
      }

      // 🎯 Новый расчёт уровня — нужно 100 XP на каждый уровень
      int xpToNextLevel = 100 * level;
      if (xp >= xpToNextLevel) {
        xp -= xpToNextLevel; // сохраняем остаток XP (если игрок накопил больше)
        level++;

        // 🔥 можно добавить визуальный эффект повышения уровня
        _cardController.forward(from: 0);
      }
    });
  }

  void _toggleLevelCard() async {
    setState(() {
      _showLevelCard = !_showLevelCard;
    });

    if (_showLevelCard) {
      _cardController.forward(from: 0);
    }
  }

  // 💰 изменение серебра
  void _changeSilver(double delta) {
    setState(() {
      silver += delta;
      if (silver < 0) silver = 0;
    });
  }

  // 💡 улучшение — даёт пассивный доход
  void _applyUpgrade(double click, double passive) {
    setState(() {
      income += passive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: kAppBackground,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Основная структура
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    child: HeaderCard(
                      views: views,
                      subs: subs,
                      money: silver,
                      income: income,
                      xp: xp,
                      level: level,
                      onAvatarTap: _toggleLevelCard,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 160, bottom: 10),
                    child: StreamImage(onTap: _onStreamTap),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: BottomTabs(
                      silver: silver,
                      onSilverChange: _changeSilver,
                      onUpgrade: _applyUpgrade,
                    ),
                  ),
                ],
              ),

              // Затемнение + popup LevelCard
              if (_showLevelCard)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Stack(
                    key: const ValueKey('overlay'),
                    children: [
                      GestureDetector(
                        onTap: _toggleLevelCard,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _showLevelCard ? 1 : 0,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: LevelCard(level: level, xp: xp),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

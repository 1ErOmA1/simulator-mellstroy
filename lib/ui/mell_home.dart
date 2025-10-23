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
  double money = 0;
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
        money += income;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cardController.dispose();
    super.dispose();
  }

  void _onStreamTap() {
    setState(() {
      views += 1;
      xp += 1;

      int earnedSubs = views ~/ 100;
      int earnedDollars = views ~/ 100;

      if (earnedSubs > subs) {
        subs = earnedSubs;
        money += (earnedDollars - money.floor()).toDouble();
      }

      if (xp >= 10 * level) {
        level++;
        xp = 0;
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

  void _changeMoney(double delta) {
    setState(() {
      money += delta;
      if (money < 0) money = 0;
    });
  }

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
                      money: money,
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
                      money: money,
                      onMoneyChange: _changeMoney,
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
                      // Размытие фона
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

                      // Popup карточка уровня
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

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
  double views = 0; // 🪙 серебро
  double silver = 0; // 💰 золото (в будущем)
  int subs = 0;

  double income = 0; // пассивный доход в серебре
  double clickIncome = 1; // доход за клик

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
        views += income;
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
      views += clickIncome;
      xp += 1;

      if (views % 100 == 0) {
        subs += 1;
        silver += 1;
      }

      int earnedSubs = (views ~/ 100).toInt();
      if (earnedSubs > subs) subs = earnedSubs;

      int xpToNextLevel = 100 * level;
      if (xp >= xpToNextLevel) {
        xp -= xpToNextLevel;
        level++;
        _cardController.forward(from: 0);
      }
    });
  }

  void _toggleLevelCard() {
    setState(() {
      _showLevelCard = !_showLevelCard;
    });
    if (_showLevelCard) _cardController.forward(from: 0);
  }

  void _changeViews(double delta) {
    setState(() {
      views += delta;
      if (views < 0) views = 0;
    });
  }

  void _applyUpgrade(double click, double passive) {
    setState(() {
      clickIncome += click;
      income += passive;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: kAppBackground,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
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
                    padding: const EdgeInsets.all(18.0),
                    child: BottomTabs(
                      silver: views,
                      onSilverChange: _changeViews,
                      onUpgrade: _applyUpgrade,
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: screenHeight * 0.06,
                left: 0,
                right: 0,
                child: Center(
                  child: StreamImage(onTap: _onStreamTap),
                ),
              ),
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

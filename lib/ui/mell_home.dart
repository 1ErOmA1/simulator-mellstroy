import 'dart:async';
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

class _MellHomeState extends State<MellHome> {
  int views = 0;
  int subs = 0;
  double money = 0;
  double income = 0;
  int xp = 0;
  int level = 1;
  bool _showLevelCard = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startIncomeTimer();
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
    super.dispose();
  }

  void _onStreamTap() {
    setState(() {
      views++;
      money += 1;
      xp += 1;
      if (xp >= 10 * level) {
        level++;
        xp = 0;
        income += 2;
      }
    });
  }

  void _toggleLevelCard() {
    setState(() {
      _showLevelCard = !_showLevelCard;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: kAppGradient,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Column(
                  children: [
                    HeaderCard(
                      views: views,
                      subs: subs,
                      money: money,
                      income: income,
                      xp: xp,
                      level: level,
                      onAvatarTap: _toggleLevelCard,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        final slideAnimation = Tween<Offset>(
                          begin: const Offset(0, -0.1),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ));
                        final fadeAnimation = CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        );
                        return SlideTransition(
                          position: slideAnimation,
                          child: FadeTransition(
                            opacity: fadeAnimation,
                            child: child,
                          ),
                        );
                      },
                      child: _showLevelCard
                          ? Padding(
                              key: const ValueKey('level'),
                              padding: const EdgeInsets.only(top: 14),
                              child: LevelCard(level: level, xp: xp),
                            )
                          : const SizedBox(key: ValueKey('empty')),
                    ),
                  ],
                ),
              ),
              StreamImage(onTap: _onStreamTap),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: BottomTabs(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

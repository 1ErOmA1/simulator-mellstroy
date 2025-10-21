import 'dart:async';
import 'package:flutter/material.dart';
import 'widgets/header_card.dart';
import 'widgets/level_card.dart';
import 'widgets/stats_row.dart';
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
        income += 2; // повышение дохода за уровень
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: kAppGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    const HeaderCard(),
                    const SizedBox(height: 14),
                    LevelCard(level: level, xp: xp),
                    const SizedBox(height: 12),
                    StatsRow(
                      views: views,
                      subs: subs,
                      money: money,
                      income: income,
                    ),
                    const SizedBox(height: 18),
                    StreamImage(onTap: _onStreamTap),
                    const SizedBox(height: 16),
                    const BottomTabs(),
                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

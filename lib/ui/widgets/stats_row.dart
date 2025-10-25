import 'package:flutter/material.dart';
import 'stat_box.dart';

class StatsRow extends StatelessWidget {
  final double views;
  final int subs;
  final double money;
  final double income;

  const StatsRow({
    super.key,
    required this.views,
    required this.subs,
    required this.money,
    required this.income,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatBox(
          imagePath: 'assets/images/silver_coin.png',
          value: views.toStringAsFixed(0),
          label: 'Серебро',
        ),
        StatBox(
          icon: Icons.group_outlined,
          value: subs.toStringAsFixed(0),
          label: 'Боровы',
        ),
        StatBox(
          imagePath: 'assets/images/gold_coin.png',
          value: money.toStringAsFixed(0),
          label: 'Золото',
        ),
        StatBox(
          icon: Icons.trending_up,
          value: income.toStringAsFixed(2),
          label: 'в сек',
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'stat_box.dart';

class StatsRow extends StatelessWidget {
  final int views;
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
        StatBox(icon: Icons.remove_red_eye_outlined, value: '$views'),
        StatBox(icon: Icons.group_outlined, value: '$subs'),
        StatBox(icon: Icons.attach_money, value: '${money.toStringAsFixed(0)}'),
        StatBox(
            icon: Icons.trending_up, value: '${income.toStringAsFixed(0)}/с'),
      ],
    );
  }
}

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
        // 🪙 Серебряная монета вместо просмотров
        StatBox(
          imagePath: 'assets/images/silver_coin.png',
          value: '$views',
          label: 'Монеты',
        ),

        // 👥 Подписчики
        StatBox(
          icon: Icons.group_outlined,
          value: '$subs',
          label: 'Боровы',
        ),

        // 💰 Золотая монета вместо денег
        StatBox(
          imagePath: 'assets/images/gold_coin.png',
          value: '${money.toStringAsFixed(0)}',
          label: 'Золото',
        ),

        // 📈 Доход
        StatBox(
          icon: Icons.trending_up,
          value: '${income.toStringAsFixed(0)}',
          label: 'в сек',
        ),
      ],
    );
  }
}

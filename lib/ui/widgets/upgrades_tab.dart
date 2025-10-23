import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpgradesTab extends StatefulWidget {
  final double money;
  final Function(double) onMoneyChange;
  final Function(double, double) onUpgrade;

  const UpgradesTab({
    super.key,
    required this.money,
    required this.onMoneyChange,
    required this.onUpgrade,
  });

  @override
  State<UpgradesTab> createState() => _UpgradesTabState();
}

class _UpgradesTabState extends State<UpgradesTab> {
  List<Map<String, dynamic>> upgrades = [
    {
      'name': 'Камера',
      'click': 0.05,
      'passive': 0.025,
      'price': 100.0,
      'level': 0
    },
    {
      'name': 'Подставка под камеру',
      'click': 0.03,
      'passive': 0.01,
      'price': 50.0,
      'level': 0
    },
    {
      'name': 'Микрофон',
      'click': 0.04,
      'passive': 0.015,
      'price': 80.0,
      'level': 0
    },
    {
      'name': 'Источник света',
      'click': 0.06,
      'passive': 0.02,
      'price': 120.0,
      'level': 0
    },
    {
      'name': 'Одежда',
      'click': 0.02,
      'passive': 0.01,
      'price': 40.0,
      'level': 0
    },
    {
      'name': 'Причёска и внешность',
      'click': 0.03,
      'passive': 0.015,
      'price': 70.0,
      'level': 0
    },
    {
      'name': 'Часы',
      'click': 0.01,
      'passive': 0.005,
      'price': 30.0,
      'level': 0
    },
    {
      'name': 'Харизма',
      'click': 0.04,
      'passive': 0.03,
      'price': 150.0,
      'level': 0
    },
    {
      'name': 'Импровизация',
      'click': 0.03,
      'passive': 0.02,
      'price': 130.0,
      'level': 0
    },
    {
      'name': 'Эрудиция',
      'click': 0.02,
      'passive': 0.02,
      'price': 110.0,
      'level': 0
    },
    {
      'name': 'Остроумие',
      'click': 0.04,
      'passive': 0.02,
      'price': 100.0,
      'level': 0
    },
    {
      'name': 'Эмоциональность',
      'click': 0.05,
      'passive': 0.03,
      'price': 160.0,
      'level': 0
    },
  ];

  void buyUpgrade(int index) {
    var upgrade = upgrades[index];
    double price = upgrade['price'];

    if (widget.money >= price) {
      setState(() {
        upgrades[index]['level']++;
        upgrades[index]['price'] *= 1.35;
      });

      widget.onMoneyChange(-price);
      widget.onUpgrade(upgrade['click'], upgrade['passive']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: upgrades.map((item) {
            final int index = upgrades.indexOf(item);
            final bool canBuy = widget.money >= item['price'];
            final int level = item['level'];

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item['name']} (x$level)',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Цена: ${item['price'].toStringAsFixed(0)} ₽',
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: canBuy ? () => buyUpgrade(index) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canBuy
                          ? const Color(0xFFFFC857)
                          : Colors.grey.shade700,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Купить',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

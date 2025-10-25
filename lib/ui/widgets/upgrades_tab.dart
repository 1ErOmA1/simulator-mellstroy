import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpgradesTab extends StatelessWidget {
  final double views;
  final List<Map<String, dynamic>> upgrades;
  final Function(int) onBuyUpgrade;

  const UpgradesTab({
    super.key,
    required this.views,
    required this.upgrades,
    required this.onBuyUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: upgrades.map((item) {
            final int index = upgrades.indexOf(item);
            final bool canBuy = views >= item['price'];
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
                        '${item['name']} (ур. $level)',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Цена: ${item['price'].toStringAsFixed(0)} серебра',
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: canBuy ? () => onBuyUpgrade(index) : null,
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

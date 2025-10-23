import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopTab extends StatefulWidget {
  final Function(double) onGoldChange;
  final Function(double) onIncomeMultiplier;

  const ShopTab({
    super.key,
    required this.onGoldChange,
    required this.onIncomeMultiplier,
  });

  @override
  State<ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> {
  bool _isDoubleActive = false;
  DateTime? _boostEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🛍 Магазин бустов",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 18),

          // 🔹 Кнопка x2 доход
          _shopButton(
            icon: Icons.bolt_rounded,
            title: "x2 заработок (на 60 сек)",
            description: "Удвоенный доход на 1 минуту",
            color: Colors.orangeAccent,
            onTap: _activateDoubleIncome,
          ),

          const SizedBox(height: 12),

          // 🔹 Кнопка +100 золотых
          _shopButton(
            icon: Icons.play_circle_fill_rounded,
            title: "+100 золотых монет",
            description: "Посмотри рекламу, чтобы получить бонус",
            color: Colors.amberAccent,
            onTap: _getGoldReward,
          ),

          const SizedBox(height: 12),

          if (_isDoubleActive)
            _boostTimer(),
        ],
      ),
    );
  }

  Widget _shopButton({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _activateDoubleIncome() {
    if (_isDoubleActive) return;

    setState(() {
      _isDoubleActive = true;
      _boostEnd = DateTime.now().add(const Duration(seconds: 60));
    });

    widget.onIncomeMultiplier(2.0);

    // Через 60 сек вернуть всё обратно
    Future.delayed(const Duration(seconds: 60), () {
      if (mounted) {
        widget.onIncomeMultiplier(1.0);
        setState(() {
          _isDoubleActive = false;
        });
      }
    });
  }

  void _getGoldReward() {
    // Здесь позже будет логика показа рекламы
    widget.onGoldChange(100);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("🎉 Ты получил 100 золотых монет!"),
        backgroundColor: Colors.amberAccent.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _boostTimer() {
    final remaining = _boostEnd!.difference(DateTime.now()).inSeconds;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        "⚡ Буст активен! Осталось: ${remaining}s",
        style: GoogleFonts.poppins(
          color: Colors.orangeAccent,
          fontSize: 13,
        ),
      ),
    );
  }
}

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
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.white.withOpacity(0.8),
                        size: 60,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "🛒 Магазин скоро откроется!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Подожди до первого обновления 🎉",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ShopTab extends StatefulWidget {
//   final Function(double) onGoldChange;
//   final Function(double) onIncomeMultiplier;

//   const ShopTab({
//     super.key,
//     required this.onGoldChange,
//     required this.onIncomeMultiplier,
//   });

//   @override
//   State<ShopTab> createState() => _ShopTabState();
// }

// class _ShopTabState extends State<ShopTab> {
//   // bool _isDoubleActive = false;
//   // DateTime? _boostEnd;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.lock_outline_rounded,
//             color: Colors.white.withOpacity(0.8),
//             size: 60,
//           ),
//           const SizedBox(height: 20),
//           Text(
//             "🛒 Магазин скоро откроется!",
//             style: GoogleFonts.poppins(
//               color: Colors.white,
//               fontWeight: FontWeight.w600,
//               fontSize: 18,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             "Подожди до первого обновления 🎉",
//             style: GoogleFonts.poppins(
//               color: Colors.white70,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

  // -------------------------------
  // 🔒 ВРЕМЕННО ОТКЛЮЧЕННЫЙ КОД:
  // -------------------------------

  /*
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
  */
//}
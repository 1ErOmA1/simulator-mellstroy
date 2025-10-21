import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomTabs extends StatelessWidget {
  const BottomTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Улучшения', style: GoogleFonts.poppins(color: Colors.white70)),
          Text('Достижения', style: GoogleFonts.poppins(color: Colors.white70)),
        ],
      ),
    );
  }
}

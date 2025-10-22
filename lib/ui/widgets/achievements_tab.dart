import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AchievementsTab extends StatelessWidget {
  const AchievementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Ачивки пока недоступны 🏅',
        style: GoogleFonts.poppins(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    );
  }
}

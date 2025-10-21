import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LevelCard extends StatelessWidget {
  final int level;
  final int xp;

  const LevelCard({super.key, required this.level, required this.xp});

  @override
  Widget build(BuildContext context) {
    final int maxXp = 10 * level;
    final double progress = xp / maxXp;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF3B1F2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: Color(0xFFFFD36A)),
              const SizedBox(width: 8),
              Text(
                'Уровень $level',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$xp / $maxXp XP',
                style: GoogleFonts.poppins(color: Colors.white38),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.black.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFFFC857)),
            ),
          ),
        ],
      ),
    );
  }
}

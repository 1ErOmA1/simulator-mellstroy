import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatBox extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String value;
  final String? label;
  final double iconSize;

  const StatBox({
    super.key,
    this.icon,
    this.imagePath,
    required this.value,
    this.label,
    this.iconSize = 22,
  }) : assert(icon != null || imagePath != null, 'icon or imagePath required');

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.03)),
        ),
        child: Column(
          children: [
            // Иконка (image или material icon)
            if (imagePath != null)
              Image.asset(
                imagePath!,
                width: iconSize,
                height: iconSize,
                fit: BoxFit.contain,
              )
            else
              Icon(icon, color: Colors.white70, size: iconSize),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (label != null) ...[
              const SizedBox(height: 4),
              Text(
                label!,
                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

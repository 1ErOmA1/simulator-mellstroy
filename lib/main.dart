import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ui/mell_home.dart';
import 'ui/theme.dart';

void main() {
  runApp(const MellCloneApp());
}

class MellCloneApp extends StatelessWidget {
  const MellCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mell Clone UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: appColorScheme,
      ),
      home: const MellHome(),
    );
  }
}

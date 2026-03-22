import 'package:flutter/material.dart';
import 'screens/scan_screen.dart';

void main() {
  runApp(const ScanWallApp());
}

class ScanWallApp extends StatelessWidget {
  const ScanWallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScanWall',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const ScanScreen(),
    );
  }
}  
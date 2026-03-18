import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ProjectTrackerApp());
}

class ProjectTrackerApp extends StatelessWidget {
  const ProjectTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A73E8)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

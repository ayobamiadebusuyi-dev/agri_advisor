import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const AgriAdvisorApp());
}

class AgriAdvisorApp extends StatelessWidget {
  const AgriAdvisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agri Advisor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F6F4A)),
      ),
      home: const HomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:journalize/features/navigation/screens/home_screen.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: HomeScreen(title: "Home"),
      ),
    );
  }
}

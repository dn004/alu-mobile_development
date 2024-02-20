import 'package:flutter/material.dart';
import 'package:journalize/features/authentication/screens/login_screen.dart';
import 'package:journalize/features/navigation/navigation.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});
  static bool isLoggedIn = true;
  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? const Navigation() : LoginPage();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:journalize/features/navigation/screens/home_screen.dart';
import 'package:journalize/providers/auth_provider.dart';
import 'package:journalize/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../../utils/next_screen.dart';

class LogInForm extends StatefulWidget {
  const LogInForm({Key? key}) : super(key: key);

  @override
  State<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthStateProvider>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool isLoading = false;
    String error = '';

    Future<void> handleEmailAndPasswordSignIn() async {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        setState(() {
          error = 'Email and Password Required!';
          print(error);
        });
      }

      try {
        setState(() {
          isLoading = true;
        });

        // Proceed with sign-in
        await authProvider.signInWithEmailAndPassword(email, password);
        print(authProvider.currentUser!.email);
        if (authProvider.currentUser != null) {
          handleAfterLogin(context);
        } else {
          setState(() {
            isLoading = false;
            error = 'wrong password or email';
            print(error);
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
          switch (e.code) {
            case 'user-not-found':
              error = 'User not found. Please check your email.';
              break;
            case 'wrong-password':
              error = 'Incorrect password. Please try again.';
              break;
            case 'invalid-email':
              error = 'Invalid email. Please try again.';
              break;
            default:
              error = 'An unexpected error occurred. Please try again.';
              break;
          }
          print(error);
        });
      } catch (_) {
        setState(() {
          isLoading = false;
          error = ' Please try again.';
          print("error: $_");
        });
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Journalize",
            style: TextStyle(fontSize: 26),
          ),
          const SizedBox(height: 8),
          Text(
            "Welcome Back, you've been missed!",
            style: TextStyle(color: MyConstants.textColor),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: "Email",
              hintStyle: TextStyle(color: Colors.grey[500]),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
            ),
            controller: emailController,
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: "Password",
              hintStyle: TextStyle(color: Colors.grey[500]),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
            ),
            controller: passwordController,
            obscureText: true,
          ),
          const SizedBox(height: 8),
          if (error.isNotEmpty)
            Text(
              error,
              style: TextStyle(color: Colors.red),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text("Forgot Password?"),
              ),
            ],
          ),
          Stack(
            children: [
              MaterialButton(
                onPressed: handleEmailAndPasswordSignIn,
                child: const Text("Sign in"),
              ),
              if (isLoading)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: MyConstants.secondaryColor,
                  ),
                  height: 76,
                  width: MyConstants.screenWidth(context),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.brown,
                      strokeWidth: 5,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void handleAfterLogin(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1000)).then((_) =>
        nextScreenReplacement(context, const HomeScreen(title: "Journalize")));
  }
}

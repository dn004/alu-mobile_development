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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isEmailPasswordLoading = false;
  bool isGoogleLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthStateProvider>();

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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text("Forgot Password?"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Stack(
              children: [
                ElevatedButton(
                  onPressed: () => handleEmailAndPasswordSignIn(context),
                  child: const Text("Sign in"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: MyConstants.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                  ),
                ),
                if (isEmailPasswordLoading)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: MyConstants.primaryColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                setState(() {
                  isGoogleLoading = true;
                });
                await authProvider.signInWithGoogle();
                setState(() {
                  isGoogleLoading = false;
                });
              },
              icon: Image.asset(
                'assets/images/google.png',
                height: 24,
                width: 24,
              ),
              label: Text('Sign in with Google'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleEmailAndPasswordSignIn(BuildContext context) async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email and Password Required!"),
      ));
      return;
    }

    setState(() {
      isEmailPasswordLoading = true;
    });

    try {
      await context
          .read<AuthStateProvider>()
          .signInWithEmailAndPassword(email, password);
      if (context.read<AuthStateProvider>().currentUser != null) {
        handleAfterLogin(context);
      } else {
        setState(() {
          isEmailPasswordLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Wrong password or email"),
        ));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isEmailPasswordLoading = false;
      });
      switch (e.code) {
        case 'user-not-found':
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("User not found. Please check your email."),
          ));
          break;
        case 'wrong-password':
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Incorrect password. Please try again."),
          ));
          break;
        case 'invalid-email':
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Invalid email. Please try again."),
          ));
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("An unexpected error occurred. Please try again."),
          ));
          break;
      }
    } catch (_) {
      setState(() {
        isEmailPasswordLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please try again."),
      ));
    }
  }

  void handleAfterLogin(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1000)).then((_) =>
        nextScreenReplacement(context, const HomeScreen(title: "Journalize")));
  }
}

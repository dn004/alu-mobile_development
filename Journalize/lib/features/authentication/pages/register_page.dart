import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:journalize/features/navigation/screens/home_screen.dart';
import 'package:journalize/providers/auth_provider.dart';
import 'package:journalize/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../../utils/next_screen.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  late AuthStateProvider authStateProvider;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authP = context.read<AuthStateProvider>();
    authStateProvider = Provider.of<AuthStateProvider>(context, listen: true);

    Future handleSingUp() async {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String username = _usernameController.text.trim();

      setState(() {
        _isLoading = true;
      });
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Fill in missing fields'),
        ));
        setState(() {
          _isLoading = false;
        });
      } else {
        try {
          await authP.signUp(email, password, username);

          setState(() {
            _isLoading = false;
          });
          if (authP.currentUser != null) {
            await FirebaseFirestore.instance.collection("users").add({
              "name": username,
              "email": authP.currentUser?.email,
              "uid": authP.currentUser?.uid,
              "photoUrl": null
            });

            context.read<AuthStateProvider>().setAuthState(authP.currentUser);
            handleAfterSignUp();
          }
        } on FirebaseAuthException catch (e) {
          String errorMessage =
              'An unexpected error occurred. Please try again.';

          setState(() {
            _isLoading = false;
          });

          switch (e.code) {
            case 'user-not-found':
              errorMessage = 'User not found. Please check your email.';
              break;
            case 'wrong-password':
              errorMessage = 'Incorrect password. Please try again.';
              break;
            case 'invalid-email':
              errorMessage = 'Invalid email. Please try again.';
              break;
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errorMessage),
          ));
        } catch (_) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('An unexpected error occurred. Please try again.'),
          ));
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: MyConstants.screenHeight(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0),
                child: Row(
                  children: [
                    Text(
                      "Let's Sign You Up!",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const SizedBox(height: 8.0),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(4)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
                controller: _usernameController,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(4)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
                controller: _emailController,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(4)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 8.0),
              const SizedBox(height: 8.0),
              const SizedBox(height: 8.0),
              Center(
                child: Stack(
                  children: [
                    ElevatedButton(
                      onPressed: handleSingUp,
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
                      child: const Text("Register"),
                    ),
                    if (_isLoading)
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
            ],
          ),
        ),
      ),
    );
  }

  handleAfterSignUp() {
    Future.delayed(const Duration(milliseconds: 200)).then((value) =>
        {nextScreen(context, const HomeScreen(title: "Journalize"))});
  }
}

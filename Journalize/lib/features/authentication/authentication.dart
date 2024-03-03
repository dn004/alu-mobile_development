import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:journalize/features/authentication/pages/login_page.dart';
import 'package:journalize/features/authentication/pages/register_page.dart';
import 'package:journalize/providers/auth_provider.dart';
import 'package:journalize/utils/constants.dart';
import 'package:provider/provider.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});
  static bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyConstants.backgroundColor,
      systemNavigationBarColor: MyConstants.backgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));
    final authStateProvider = Provider.of<AuthStateProvider>(context);

    return Scaffold(
      backgroundColor: MyConstants.backgroundColor,
      body: SafeArea(
        child: SizedBox(
          height: MyConstants.screenHeight(context),
          width: MyConstants.screenWidth(context),
          child: Column(children: [
            Expanded(
                flex: 10,
                child: SizedBox(
                    width: MyConstants.screenWidth(context),
                    child: SingleChildScrollView(
                      child: authStateProvider.signedState
                          ? const LogInForm()
                          : const RegisterForm(),
                    ))),
            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                width: MyConstants.screenWidth(context),
                child: authStateProvider.signedState
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Not a Member?",
                            style: TextStyle(color: MyConstants.textColor),
                          ),
                          TextButton(
                            onPressed: authStateProvider.toggleSigned,
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            child: const Text("Register"),
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already a member?",
                            style: TextStyle(color: MyConstants.textColor),
                          ),
                          TextButton(
                            onPressed: authStateProvider.toggleSigned,
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            child: const Text("Log in!"),
                          )
                        ],
                      ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

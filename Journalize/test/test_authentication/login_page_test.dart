import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journalize/features/authentication/pages/login_page.dart';
import 'package:journalize/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}


void main() {
  group('Login Form Widget Test', () {
    testWidgets('TextFields Test', (WidgetTester tester) async {
      final mockFirebaseAuth = MockFirebaseAuth();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<AuthStateProvider>.value(
              value: AuthStateProvider(firebaseAuth: mockFirebaseAuth),
              child: const LogInForm(),
            ),
          ),
        ),
      );
      await tester.enterText(find.byKey(const ValueKey("emailTextField")), "test@email");
      await tester.enterText(find.byKey(const ValueKey("passwordTextField")), "testpassword");
      await tester.pump();

      expect(find.text("test@email"), findsOneWidget);
      expect(find.text("testpassword"), findsOneWidget);
    });
    testWidgets('buttons Test', (WidgetTester tester) async {
      final mockFirebaseAuth = MockFirebaseAuth();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<AuthStateProvider>.value(
              value: AuthStateProvider(firebaseAuth: mockFirebaseAuth),
              child: const LogInForm(),
            ),
          ),
        ),
      );

      await tester.ensureVisible(find.byKey(const ValueKey("forgot_password_button")));
      await tester.ensureVisible(find.byKey(const ValueKey("googleSignInButtonKey")));
      await tester.pump();

      expect(find.text("Forgot Password?"), findsOne);
      expect(find.text("Sign in with Google"), findsOne);
    });
  });
}

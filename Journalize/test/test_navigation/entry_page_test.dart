import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journalize/features/navigation/widgets/entry_page.dart';
import 'package:journalize/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}


void main() {
  //FIRERSTORE COMPLICATIONS.




  // group('Entry Page Test', () {
    
  //   testWidgets('TextFields Test', (WidgetTester tester) async {
  //     final mockFirebaseAuth = MockFirebaseAuth();

  //     await tester.pumpWidget(
  //       MaterialApp(
  //         home: Scaffold(
  //           body: ChangeNotifierProvider<AuthStateProvider>.value(
  //             value: AuthStateProvider(firebaseAuth: mockFirebaseAuth),
  //             child: const Entries(),
  //           ),
  //         ),
  //       ),
  //     );
  //   expect(find.byType(CircularProgressIndicator), findsOneWidget);

  //   await tester.pump(const Duration(seconds: 1));

  //   expect(find.byType(CircularProgressIndicator), findsNothing);

  //   expect(find.byType(GridView), findsOneWidget);
  //   });
  // });
}

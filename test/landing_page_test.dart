import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/home_page.dart';
import 'package:time_tracker/app/landing_page.dart';
import 'package:time_tracker/app/sign_in/sign_in_page.dart';
import 'package:time_tracker/services/auth.dart';

import 'landing_page_test.mocks.dart';

class MockAuth extends Mock implements AuthBase {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuth mockAuth;
  late StreamController<User?> onAuthStateChangedController;
  late final MockDatabase mockDatabase;

  setUp(() {
    mockAuth = MockAuth();
    mockDatabase = MockDatabase();
    onAuthStateChangedController = StreamController<User>();
  });

  tearDown(() {
    onAuthStateChangedController.close();
  });

  Future<void> pumpLandingPage(WidgetTester tester) async{
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: LandingPage(),
        ),
      ),
    );
  }

  void stubOnAuthStateChangeYields(Iterable<User> onAuthStateChanged) {
    when(mockAuth.authStateChanges()).thenAnswer(
            (_) {
              return Stream<User>.fromIterable(onAuthStateChanged);
            });
  }

  testWidgets("stream waiting", (WidgetTester tester) async{
    stubOnAuthStateChangeYields([]);

    await pumpLandingPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

  });

  testWidgets('null user', (WidgetTester tester) async {
    stubOnAuthStateChangeYields([]);

    await pumpLandingPage(tester);

    expect(find.byType(SignInPage), findsOneWidget);
  }, skip: true);

  testWidgets('non-null user', (WidgetTester tester) async {
    final mockUser = MockUser();
    when(mockUser.uid).thenReturn('123');
    stubOnAuthStateChangeYields([mockUser]);

    await pumpLandingPage(tester);

    expect(find.byType(HomePage), findsOneWidget);
  }, skip: true);

}

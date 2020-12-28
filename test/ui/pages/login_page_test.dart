import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

import 'package:for_dev/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

main() {
  group('LoginPage', () {
    LoginPresenter presenter;
    StreamController<String> emailErrorController;

    Future<void> loadPage(WidgetTester tester) async {
      presenter = LoginPresenterSpy();
      emailErrorController = StreamController();
      when(presenter.emailErrorStream)
          .thenAnswer((_) => emailErrorController.stream);

      final loginPage = MaterialApp(
        home: LoginPage(presenter),
      );

      await tester.pumpWidget(loginPage);
    }

    tearDown(() {
      emailErrorController.close();
    });

    testWidgets('should load with correct initialState', (tester) async {
      await loadPage(tester);

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      );

      expect(
        emailTextChildren,
        findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the labelText.',
      );

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );

      expect(
        passwordTextChildren,
        findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the labelText.',
      );

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));

      expect(button.onPressed, null);
    });

    testWidgets('should call validate with correct values', (tester) async {
      await loadPage(tester);

      final email = faker.internet.email();
      await tester.enterText(find.bySemanticsLabel('Email'), email);
      verify(presenter.validateEmail(email));

      final password = faker.internet.password();
      await tester.enterText(find.bySemanticsLabel('Senha'), password);
      verify(presenter.validatePassword(password));
    });

    testWidgets('should present error if email is invalid', (tester) async {
      await loadPage(tester);

      final error = 'any error';

      emailErrorController.add(error);

      await tester.pump();

      expect(find.text(error), findsOneWidget);
    });

    testWidgets('should present no error if email is valid', (tester) async {
      await loadPage(tester);

      emailErrorController.add(null);

      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel('Email'),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should present no error if email is valid', (tester) async {
      await loadPage(tester);

      emailErrorController.add('');

      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel('Email'),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    });
  });
}

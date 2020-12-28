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
    StreamController<String> passwordErrorController;
    StreamController<String> mainErrorController;
    StreamController<bool> isFormValidController;
    StreamController<bool> isLoadingController;

    Future<void> loadPage(WidgetTester tester) async {
      presenter = LoginPresenterSpy();
      emailErrorController = StreamController();
      passwordErrorController = StreamController();
      mainErrorController = StreamController();
      isFormValidController = StreamController();
      isLoadingController = StreamController();

      when(presenter.emailErrorStream)
          .thenAnswer((_) => emailErrorController.stream);
      when(presenter.passwordErrorStream)
          .thenAnswer((_) => passwordErrorController.stream);
      when(presenter.mainErrorStream)
          .thenAnswer((_) => mainErrorController.stream);
      when(presenter.isFormValidStream)
          .thenAnswer((_) => isFormValidController.stream);
      when(presenter.isLoadingStream)
          .thenAnswer((_) => isLoadingController.stream);

      final loginPage = MaterialApp(
        home: LoginPage(presenter),
      );

      await tester.pumpWidget(loginPage);
    }

    tearDown(() {
      emailErrorController.close();
      passwordErrorController.close();
      mainErrorController.close();
      isFormValidController.close();
      isLoadingController.close();
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
      expect(find.byType(CircularProgressIndicator), findsNothing);
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

    testWidgets('should present error if password is invalid', (tester) async {
      await loadPage(tester);

      final error = 'any error';

      passwordErrorController.add(error);

      await tester.pump();

      expect(find.text(error), findsOneWidget);
    });

    testWidgets('should present no error if password is valid', (tester) async {
      await loadPage(tester);

      passwordErrorController.add(null);

      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel('Senha'),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should present no error if password is valid', (tester) async {
      await loadPage(tester);

      passwordErrorController.add('');

      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel('Senha'),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    });

    testWidgets('should enable button if form is valid', (tester) async {
      await loadPage(tester);

      isFormValidController.add(true);

      await tester.pump();

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));

      expect(
        button.onPressed,
        isNotNull,
      );
    });

    testWidgets('should disable button if form is invalid', (tester) async {
      await loadPage(tester);

      isFormValidController.add(false);

      await tester.pump();

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));

      expect(
        button.onPressed,
        null,
      );
    });

    testWidgets('should call authentication on form submit', (tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await tester.pump();
      await tester.tap(find.byType(RaisedButton));
      await tester.pump();

      verify(presenter.auth()).called(1);
    });

    testWidgets('should present loading', (tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should hide loading', (tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await tester.pump();

      isLoadingController.add(false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should present if auth fails', (tester) async {
      await loadPage(tester);

      final error = 'main error';

      mainErrorController.add(error);
      await tester.pump();

      expect(find.text(error), findsOneWidget);
    });
  });
}

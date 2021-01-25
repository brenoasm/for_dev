import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';

import 'package:mockito/mockito.dart';

import 'package:for_dev/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

main() {
  group('SignUpPage', () {
    Future<void> loadPage(WidgetTester tester) async {
      final signUpPage = GetMaterialApp(
        initialRoute: '/signup',
        getPages: [
          GetPage(name: '/signup', page: () => SignUpPage()),
        ],
      );

      await tester.pumpWidget(signUpPage);
    }

    testWidgets('should load with correct initialState', (tester) async {
      await loadPage(tester);

      final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel('Nome'),
        matching: find.byType(Text),
      );

      expect(
        nameTextChildren,
        findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the labelText.',
      );

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

      final passwordConfirmationTextChildren = find.descendant(
        of: find.bySemanticsLabel('Confirmar senha'),
        matching: find.byType(Text),
      );

      expect(
        passwordConfirmationTextChildren,
        findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the labelText.',
      );

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));

      expect(button.onPressed, null);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}

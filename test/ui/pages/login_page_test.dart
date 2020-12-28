import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:for_dev/ui/pages/login_page.dart';

main() {
  group('LoginPage', () {
    Future<void> loadPage(WidgetTester tester) async {
      final loginPage = MaterialApp(
        home: LoginPage(),
      );

      await tester.pumpWidget(loginPage);
    }

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

    testWidgets('should call validate with correct values', (tester) async {});
  });
}

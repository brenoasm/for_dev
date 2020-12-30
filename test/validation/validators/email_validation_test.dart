import 'package:test/test.dart';

import 'package:for_dev/validation/protocols/protocols.dart';

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation(this.field);

  String validate(String value) {
    return null;
  }
}

main() {
  group('EmailValidation', () {
    test('should return null if email is empty', () async {
      final sut = EmailValidation('any_field');

      final error = sut.validate('');

      expect(error, null);
    });

    test('should return null if email is null', () async {
      final sut = EmailValidation('any_field');

      final error = sut.validate(null);

      expect(error, null);
    });
  });
}

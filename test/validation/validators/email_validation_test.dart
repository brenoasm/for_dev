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
    EmailValidation sut;

    setUp(() async {
      sut = EmailValidation('any_field');
    });

    test('should return null if email is empty', () async {
      expect(sut.validate(''), null);
    });

    test('should return null if email is null', () async {
      expect(sut.validate(null), null);
    });
  });
}

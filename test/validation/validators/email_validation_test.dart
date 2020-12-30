import 'package:test/test.dart';

import 'package:for_dev/validation/validators/validators.dart';

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

    test('should return null if email is valid', () async {
      expect(sut.validate('breno.augusto@gmail.com'), null);
    });

    test('should return error if email is invalid', () async {
      expect(sut.validate('breno.augusto'), 'Campo inválido');
    });
  });
}

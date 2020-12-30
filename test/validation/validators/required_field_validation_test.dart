import 'package:test/test.dart';

import 'package:for_dev/validation/validators/validators.dart';

main() {
  group('RequiredFieldValidation', () {
    RequiredFieldValidation sut;

    setUp(() async {
      sut = RequiredFieldValidation('any_field');
    });

    test('should return null if value is not empty', () async {
      expect(sut.validate('any_value'), null);
    });

    test('should return error if value is empty', () async {
      expect(sut.validate(''), 'Campo Obrigatório');
    });

    test('should return error if value is null', () async {
      expect(sut.validate(null), 'Campo Obrigatório');
    });
  });
}

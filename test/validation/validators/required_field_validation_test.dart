import 'package:test/test.dart';

abstract class FieldValidation {
  String get field;

  String validate(String value);
}

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String validate(String value) {
    return value.isEmpty ? 'Campo Obrigatório' : null;
  }
}

main() {
  group('RequiredFieldValidation', () {
    test('should return null if value is not empty', () async {
      final sut = RequiredFieldValidation('any_field');

      final error = sut.validate('any_value');

      expect(error, null);
    });

    test('should return error if value is empty', () async {
      final sut = RequiredFieldValidation('any_field');

      final error = sut.validate('');

      expect(error, 'Campo Obrigatório');
    });
  });
}

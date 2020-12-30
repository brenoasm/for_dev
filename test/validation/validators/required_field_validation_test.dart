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
  });
}

import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/presentation/protocols/protocols.dart';
import 'package:for_dev/validation/protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String validate({@required String field, @required String value}) {
    String error;

    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(value);

      if (error?.isNotEmpty == true) {
        break;
      }
    }

    return error;
  }
}

class FieldValidationSpy extends Mock implements FieldValidation {}

main() {
  group('ValidationComposite', () {
    ValidationComposite sut;
    FieldValidationSpy validation1;
    FieldValidationSpy validation2;
    FieldValidationSpy validation3;

    void mockValidation1(String error) {
      when(validation1.validate(any)).thenReturn(error);
    }

    void mockValidation2(String error) {
      when(validation2.validate(any)).thenReturn(error);
    }

    void mockValidation3(String error) {
      when(validation3.validate(any)).thenReturn(error);
    }

    setUp(() async {
      validation1 = FieldValidationSpy();
      when(validation1.field).thenReturn('other_field');
      mockValidation1(null);

      validation2 = FieldValidationSpy();
      when(validation2.field).thenReturn('any_field');
      mockValidation2(null);

      validation3 = FieldValidationSpy();
      when(validation3.field).thenReturn('any_field');
      mockValidation3(null);

      sut = ValidationComposite([validation1, validation2, validation3]);
    });

    test('should return null if all validations returns null or empty',
        () async {
      mockValidation2('');

      final error = sut.validate(field: 'any_field', value: 'any_value');

      expect(error, null);
    });

    test('should return the first error', () async {
      mockValidation1('error_1');
      mockValidation2('error_2');
      mockValidation3('error_3');

      final error = sut.validate(field: 'any_field', value: 'any_value');

      expect(error, 'error_2');
    });
  });
}

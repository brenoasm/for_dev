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
    return null;
  }
}

class FieldValidationSpy extends Mock implements FieldValidation {}

main() {
  group('ValidationComposite', () {
    test('should return null if all validations returns null or empty',
        () async {
      final validation1 = FieldValidationSpy();
      when(validation1.field).thenReturn('any_field');
      when(validation1.validate(any)).thenReturn(null);

      final validation2 = FieldValidationSpy();
      when(validation1.field).thenReturn('any_field');
      when(validation1.validate(any)).thenReturn('');

      final sut = ValidationComposite([validation1, validation2]);

      final error = sut.validate(field: 'any_field', value: 'any_value');

      expect(error, null);
    });
  });
}

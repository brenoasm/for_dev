import 'package:test/test.dart';

import 'package:for_dev/main/factories/factories.dart';
import 'package:for_dev/validation/validators/validators.dart';

main() {
  group('LoginValidationFactory', () {
    test('should return the correct validations', () async {
      final validations = makeLoginValidations();

      expect(validations, [
        RequiredFieldValidation('email'),
        EmailValidation('email'),
        RequiredFieldValidation('password'),
      ]);
    });
  });
}

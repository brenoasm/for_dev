import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:for_dev/presentation/presenters/presenters.dart';
import 'package:for_dev/presentation/protocols/validation.dart';

class ValidationSpy extends Mock implements Validation {}

main() {
  group('StreamLoginPresenter', () {
    StreamLoginPresenter sut;
    ValidationSpy validation;
    String email;

    PostExpectation mockValidationCall(String field) => when(
          validation.validate(
            field: field == null ? anyNamed('field') : field,
            value: anyNamed('value'),
          ),
        );

    void mockValidation({String field, String value}) {
      mockValidationCall(field).thenReturn(value);
    }

    setUp(() async {
      validation = ValidationSpy();
      sut = StreamLoginPresenter(validation: validation);
      email = faker.internet.email();
      mockValidation();
    });

    test('should call Validation with correct email', () async {
      sut.validateEmail(email);

      verify(validation.validate(field: 'email', value: email)).called(1);
    });

    test('should emit email error if validation fails', () async {
      mockValidation(value: 'error');

      sut.emailErrorStream.listen(
        expectAsync1((error) => expect(error, 'error')),
      );

      sut.isFormValidStream.listen(
        expectAsync1((isValid) => expect(isValid, false)),
      );

      sut.validateEmail(email);
      sut.validateEmail(email);
    });

    test('should emit null if validation succeeds', () async {
      sut.emailErrorStream.listen(
        expectAsync1((error) => expect(error, null)),
      );

      sut.isFormValidStream.listen(
        expectAsync1((isValid) => expect(isValid, false)),
      );

      sut.validateEmail(email);
      sut.validateEmail(email);
    });
  });
}

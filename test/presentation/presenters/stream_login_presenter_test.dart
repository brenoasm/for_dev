import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

abstract class Validation {
  String validate({@required String field, @required String value});
}

class StreamLoginPresenter {
  final Validation validation;

  StreamLoginPresenter({@required this.validation});

  void validateEmail(String value) {
    validation.validate(field: 'email', value: value);
  }
}

class ValidationSpy extends Mock implements Validation {}

main() {
  group('StreamLoginPresenter', () {
    test('should call Validation with correct email', () async {
      final validation = ValidationSpy();
      final sut = StreamLoginPresenter(validation: validation);
      final email = faker.internet.email();

      sut.validateEmail(email);

      verify(validation.validate(field: 'email', value: email)).called(1);
    });
  });
}

import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

abstract class Validation {
  String validate({@required String field, @required String value});
}

class LoginState {
  String emailError;
}

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError);

  StreamLoginPresenter({@required this.validation});

  void validateEmail(String value) {
    _state.emailError = validation.validate(field: 'email', value: value);

    _controller.add(_state);
  }
}

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

      expectLater(sut.emailErrorStream, emits('error'));

      sut.validateEmail(email);
    });
  });
}

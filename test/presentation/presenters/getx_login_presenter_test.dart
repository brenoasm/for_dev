import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:for_dev/presentation/presenters/presenters.dart';
import 'package:for_dev/presentation/protocols/validation.dart';

import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/helpers/helpers.dart';
import 'package:for_dev/domain/usecases/usecases.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

main() {
  group('GetxLoginPresenter', () {
    GetxLoginPresenter sut;
    ValidationSpy validation;
    AuthenticationSpy authentication;
    SaveCurrentAccountSpy saveCurrentAccount;
    String email;
    String password;
    String token;

    PostExpectation mockValidationCall(String field) => when(
          validation.validate(
            field: field == null ? anyNamed('field') : field,
            value: anyNamed('value'),
          ),
        );

    void mockValidation({String field, String value}) {
      mockValidationCall(field).thenReturn(value);
    }

    PostExpectation mockAutheticationCall() => when(
          authentication.auth(any),
        );

    PostExpectation mockSaveCurrentAccountCall() => when(
          saveCurrentAccount.save(any),
        );

    void mockAuthentication() {
      mockAutheticationCall().thenAnswer(
        (_) async => AccountEntity(token),
      );
    }

    void mockAuthenticationError(DomainError error) {
      mockAutheticationCall().thenThrow(error);
    }

    void mockSaveCurrentAccountError() {
      mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
    }

    setUp(() async {
      validation = ValidationSpy();
      authentication = AuthenticationSpy();
      saveCurrentAccount = SaveCurrentAccountSpy();
      sut = GetxLoginPresenter(
        validation: validation,
        authentication: authentication,
        saveCurrentAccount: saveCurrentAccount,
      );
      email = faker.internet.email();
      password = faker.internet.password();
      token = faker.guid.guid();
      mockValidation();
      mockAuthentication();
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

    test('should not emit emailError if email validation succeeds', () async {
      sut.emailErrorStream.listen(
        expectAsync1((error) => expect(error, null)),
      );

      sut.isFormValidStream.listen(
        expectAsync1((isValid) => expect(isValid, false)),
      );

      sut.validateEmail(email);
      sut.validateEmail(email);
    });

    test('should call Validation with correct password', () async {
      sut.validatePassword(password);

      verify(validation.validate(field: 'password', value: password)).called(1);
    });

    test('should emit password error if validation fails', () async {
      mockValidation(value: 'error');

      sut.passwordErrorStream.listen(
        expectAsync1((error) => expect(error, 'error')),
      );

      sut.isFormValidStream.listen(
        expectAsync1((isValid) => expect(isValid, false)),
      );

      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('Should emit null if validation succeeds', () {
      sut.passwordErrorStream
          .listen(expectAsync1((error) => expect(error, null)));
      sut.isFormValidStream
          .listen(expectAsync1((isValid) => expect(isValid, false)));

      sut.validatePassword(password);
      sut.validatePassword(password);
    });

    test('should emit password error if validation fails', () async {
      mockValidation(field: 'email', value: 'error');

      sut.emailErrorStream.listen(
        expectAsync1((error) => expect(error, 'error')),
      );

      sut.passwordErrorStream.listen(
        expectAsync1((error) => expect(error, null)),
      );

      sut.isFormValidStream.listen(
        expectAsync1((isValid) => expect(isValid, false)),
      );

      sut.validateEmail(email);
      sut.validatePassword(password);
    });

    test('should emit password error if validation fails', () async {
      sut.emailErrorStream.listen(
        expectAsync1((error) => expect(error, null)),
      );

      sut.passwordErrorStream.listen(
        expectAsync1((error) => expect(error, null)),
      );

      expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

      sut.validateEmail(email);

      await Future.delayed(Duration.zero);

      sut.validatePassword(password);
    });

    test('should call Authentication with correct values', () async {
      sut.validateEmail(email);
      sut.validatePassword(password);

      await sut.auth();

      verify(
        authentication.auth(
          AuthenticationParams(email: email, secret: password),
        ),
      ).called(1);
    });

    test('should call SaveCurrentAccount with correct value', () async {
      sut.validateEmail(email);
      sut.validatePassword(password);

      await sut.auth();

      verify(
        saveCurrentAccount.save(
          AccountEntity(token),
        ),
      ).called(1);
    });

    test('should emit UnexpectedError if SaveCurrentAccount fails', () async {
      mockSaveCurrentAccountError();

      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.mainErrorStream.listen(
        expectAsync1((error) =>
            expect(error, 'Algo errado aconteceu. Tente novamente em breve')),
      );

      await sut.auth();
    });

    test('should emit correct events on Authentication success', () async {
      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(sut.isLoadingStream, emits(true));

      await sut.auth();
    });

    test('should emit correct events on InvalidCredentialsError', () async {
      mockAuthenticationError(DomainError.invalidCredentials);

      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.mainErrorStream.listen(
        expectAsync1((error) => expect(error, 'Credenciais inválidas')),
      );

      await sut.auth();
    });

    test('should emit correct events on UnexpectedError', () async {
      mockAuthenticationError(DomainError.unexpected);

      sut.validateEmail(email);
      sut.validatePassword(password);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.mainErrorStream.listen(
        expectAsync1((error) =>
            expect(error, 'Algo errado aconteceu. Tente novamente em breve')),
      );

      await sut.auth();
    });

    test('should change page on success', () async {
      sut.validateEmail(email);
      sut.validatePassword(password);

      sut.navigateToStream.listen(
        expectAsync1((page) => expect(page, '/surveys')),
      );

      await sut.auth();
    });
  });
}

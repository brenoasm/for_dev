import 'package:for_dev/domain/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:for_dev/domain/usecases/usecases.dart';

import 'package:for_dev/data/usecases/usecases.dart';
import 'package:for_dev/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}

main() {
  group('RemoteAddAccount', () {
    HttpClient httpClient;
    String url;
    RemoteAddAccount sut;
    AddAccountParams params;

    Map mockValidData() => {
          'accessToken': faker.guid.guid(),
          'name': faker.person.name(),
        };

    PostExpectation mockRequest() => when(
          httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body'),
          ),
        );

    void mockHttpData(Map data) {
      mockRequest().thenAnswer(
        (_) async => data,
      );
    }

    void mockHttpError(HttpError error) {
      mockRequest().thenThrow(error);
    }

    setUp(() async {
      httpClient = HttpClientSpy();
      url = faker.internet.httpUrl();
      sut = RemoteAddAccount(httpClient: httpClient, url: url);
      params = AddAccountParams(
        name: faker.person.name(),
        email: faker.internet.email(),
        password: faker.internet.password(),
        passwordConfirmation: faker.internet.password(),
      );
    });

    test('should call http client with correct values', () async {
      await sut.add(params);

      verify(
        httpClient.request(
          url: url,
          method: 'post',
          body: {
            'name': params.name,
            'email': params.email,
            'password': params.password,
            'passwordConfirmation': params.passwordConfirmation,
          },
        ),
      );
    });

    test('should throw UnexpectedError if HttpClient returns 400', () async {
      mockHttpError(HttpError.badRequest);

      final future = sut.add(params);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if HttpClient returns 404', () async {
      mockHttpError(HttpError.notFound);

      final future = sut.add(params);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if HttpClient returns 500', () async {
      mockHttpError(HttpError.serverError);

      final future = sut.add(params);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw InvalidCredentialsError if HttpClient returns 403',
        () async {
      mockHttpError(HttpError.forbidden);

      final future = sut.add(params);

      expect(future, throwsA(DomainError.emailInUse));
    });
  });
}

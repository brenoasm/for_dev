import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:for_dev/domain/helpers/helpers.dart';
import 'package:for_dev/domain/usecases/usecases.dart';

import 'package:for_dev/data/usecases/usecases.dart';
import 'package:for_dev/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}

main() {
  group('RemoteAuthentication', () {
    HttpClient httpClient;
    String url;
    RemoteAuthentication sut;
    AuthenticationParams params;

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
      sut = RemoteAuthentication(httpClient: httpClient, url: url);
      params = AuthenticationParams(
        email: faker.internet.email(),
        secret: faker.internet.password(),
      );
      mockHttpData(mockValidData());
    });

    test('should call http client with correct values', () async {
      await sut.auth(params);

      verify(
        httpClient.request(
          url: url,
          method: 'post',
          body: {
            'email': params.email,
            'password': params.secret,
          },
        ),
      );
    });

    test('should throw UnexpectedError if HttpClient returns 400', () async {
      mockHttpError(HttpError.badRequest);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if HttpClient returns 404', () async {
      mockHttpError(HttpError.notFound);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if HttpClient returns 500', () async {
      mockHttpError(HttpError.serverError);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw InvalidCredentialsError if HttpClient returns 401',
        () async {
      mockHttpError(HttpError.unauthorized);

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.invalidCredentials));
    });

    test('should return an Account if HttpClient returns 200', () async {
      final validData = mockValidData();
      mockHttpData(validData);

      final account = await sut.auth(params);

      expect(account.token, validData['accessToken']);
    });

    test(
        'should throw UnexpectedError if HttpClient returns 200 with invalid data',
        () async {
      mockHttpData({'invalid_key': 'invalid_value'});

      final future = sut.auth(params);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}

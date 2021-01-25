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
  });
}

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import 'package:for_dev/domain/usecases/authentication.dart';

abstract class HttpClient {
  Future<void> request({
    @required String url,
    @required String method,
    Map body,
  }) async {}
}

class HttpClientSpy extends Mock implements HttpClient {}

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> auth(AuthenticationParams params) async {
    final body = {'email': params.email, 'password': params.secret};

    await httpClient.request(url: url, method: 'post', body: body);
  }
}

main() {
  group('RemoteAuthentication', () {
    HttpClient httpClient;
    String url;
    RemoteAuthentication sut;

    setUp(() async {
      httpClient = HttpClientSpy();
      url = faker.internet.httpUrl();
      sut = RemoteAuthentication(httpClient: httpClient, url: url);
    });

    test('should call http client with correct values', () async {
      final params = AuthenticationParams(
        email: faker.internet.email(),
        secret: faker.internet.password(),
      );
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
  });
}

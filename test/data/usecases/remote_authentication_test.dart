import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

abstract class HttpClient {
  Future<void> request({
    @required String url,
    @required String method,
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

  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}

main() {
  group('RemoteAuthentication', () {
    test('should call http client with correct values', () async {
      final httpClient = HttpClientSpy();
      final url = faker.internet.httpUrl();
      final sut = RemoteAuthentication(httpClient: httpClient, url: url);

      await sut.auth();

      verify(httpClient.request(url: url, method: 'post'));
    });
  });
}

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    await client.post(url, headers: headers);
  }
}

class ClientSpy extends Mock implements Client {}

main() {
  ClientSpy client;
  HttpAdapter sut;
  String url;

  setUp(() async {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('HttpAdapter | Post', () {
    test('should call post with correct values', () async {
      await sut.request(url: url, method: 'post');

      verify(
        client.post(
          url,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );
    });
  });
}

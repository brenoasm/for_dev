import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import 'package:for_dev/data/http/http.dart';

import 'package:for_dev/infra/http/http.dart';

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
    PostExpectation mockRequest() => when(
          client.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        );

    void mockResponse(
      int statusCode, {
      String body = '{"any_key":"any_value"}',
    }) {
      mockRequest().thenAnswer(
        (_) async => Response(body, statusCode),
      );
    }

    setUp(() async {
      mockResponse(200);
    });

    test('should call post with correct values', () async {
      await sut.request(
        url: url,
        method: 'post',
        body: {'any_key': 'any_value'},
      );

      verify(
        client.post(
          url,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: '{"any_key":"any_value"}',
        ),
      );
    });

    test('should call post with correct without body', () async {
      await sut.request(
        url: url,
        method: 'post',
      );

      verify(
        client.post(any, headers: anyNamed('headers')),
      );
    });

    test('should return data if post returns 200', () async {
      when(
        client.post(
          any,
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => Response('{"any_key":"any_value"}', 200),
      );

      final result = await sut.request(url: url, method: 'post');

      expect(result, {'any_key': 'any_value'});
    });

    test('should return null if post returns 200 with no data', () async {
      mockResponse(200, body: '');

      final result = await sut.request(url: url, method: 'post');

      expect(result, null);
    });

    test('should return null if post returns 204', () async {
      mockResponse(204, body: '');

      final result = await sut.request(url: url, method: 'post');

      expect(result, null);
    });

    test('should return null if post returns 204 with data', () async {
      mockResponse(204);

      final result = await sut.request(url: url, method: 'post');

      expect(result, null);
    });

    test('should return BadRequestError if post returns 400 with no data',
        () async {
      mockResponse(400, body: '');

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return BadRequestError if post returns 400', () async {
      mockResponse(400);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return UnauthorizedError if post returns 401', () async {
      mockResponse(401);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('should return ForbiddenError if post returns 403', () async {
      mockResponse(403);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.forbidden));
    });

    test('should return NotFoundError if post returns 404', () async {
      mockResponse(404);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.notFound));
    });

    test('should return ServerError if post returns 500', () async {
      mockResponse(500);

      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}

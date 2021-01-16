import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

main() {
  group('LocalStorageAdapter', () {
    LocalStorageAdapter sut;
    String key;
    String value;
    FlutterSecureStorageSpy secureStorage;

    setUp(() async {
      key = faker.lorem.word();
      value = faker.guid.guid();
      secureStorage = FlutterSecureStorageSpy();
      sut = LocalStorageAdapter(secureStorage: secureStorage);
    });

    group('SaveSecure', () {
      void mockSaveSecureError() {
        when(
          secureStorage.write(
            key: anyNamed('key'),
            value: anyNamed('value'),
          ),
        ).thenThrow(Exception());
      }

      test('should call save secure with correct values', () async {
        await sut.saveSecure(key: key, value: value);

        verify(secureStorage.write(key: key, value: value));
      });

      test('should throw if save secure throws', () async {
        mockSaveSecureError();

        final future = sut.saveSecure(key: key, value: value);

        expect(future, throwsA(TypeMatcher<Exception>()));
      });
    });

    group('FetchSecure', () {
      PostExpectation mockFetchSecureCall() => when(
            secureStorage.read(
              key: anyNamed('key'),
            ),
          );

      void mockFetchSecureError() {
        mockFetchSecureCall().thenThrow(Exception());
      }

      void mockFetchSecure() {
        mockFetchSecureCall().thenAnswer((_) async => value);
      }

      setUp(() async {
        mockFetchSecure();
      });

      test('should call fetch secure with correct value', () async {
        await sut.fetchSecure(key);

        verify(secureStorage.read(key: key));
      });

      test('should return correct value on success', () async {
        final fetchedValue = await sut.fetchSecure(key);

        expect(fetchedValue, value);
      });

      test('should throw if fetch secure throws', () async {
        mockFetchSecureError();

        final future = sut.fetchSecure(key);

        expect(future, throwsA(TypeMatcher<Exception>()));
      });
    });
  });
}

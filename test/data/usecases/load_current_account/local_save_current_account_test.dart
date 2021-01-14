import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/data/cache/cache.dart';
import 'package:for_dev/data/usecases/usecases.dart';

import 'package:for_dev/domain/helpers/helpers.dart';
import 'package:for_dev/domain/entities/entities.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

main() {
  group('LocalSaveCurrentAccount', () {
    String token;
    LocalLoadCurrentAccount sut;
    FetchSecureCacheStorageSpy fetchSecureCacheStorage;

    PostExpectation mockFetchSecureCall() =>
        when(fetchSecureCacheStorage.fetchSecure(any));

    void mockFetchSecure() {
      mockFetchSecureCall().thenAnswer((_) async => token);
    }

    void mockFetchSecureError() {
      mockFetchSecureCall().thenThrow(Exception());
    }

    setUp(() async {
      fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
      sut = LocalLoadCurrentAccount(
          fetchSecureCacheStorage: fetchSecureCacheStorage);
      token = faker.guid.guid();

      mockFetchSecure();
    });

    test('should call FetchSecureCacheStorage with correct value', () async {
      await sut.load();

      verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
    });

    test('should return an AccountEntity', () async {
      final account = await sut.load();

      expect(account, AccountEntity(token));
    });

    test('should throw UnexpectedError if FetchSecureCacheStorage throws',
        () async {
      mockFetchSecureError();

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}

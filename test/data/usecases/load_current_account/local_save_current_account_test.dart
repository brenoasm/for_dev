import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/domain/usecases/usecases.dart';
import 'package:for_dev/domain/entities/entities.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorage});

  Future<AccountEntity> load() async {
    final token = await fetchSecureCacheStorage.fetchSecure('token');

    return AccountEntity(token);
  }
}

abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure(String key);
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

main() {
  group('LocalSaveCurrentAccount', () {
    String token;
    LocalLoadCurrentAccount sut;
    FetchSecureCacheStorageSpy fetchSecureCacheStorage;

    void mockFetchSecure() {
      when(fetchSecureCacheStorage.fetchSecure(any))
          .thenAnswer((_) async => token);
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
  });
}

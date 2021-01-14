import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LocalLoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorage});

  Future<void> load() async {
    await fetchSecureCacheStorage.fetchSecure('token');
  }
}

abstract class FetchSecureCacheStorage {
  Future<void> fetchSecure(String key);
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

main() {
  group('LocalSaveCurrentAccount', () {
    LocalLoadCurrentAccount sut;
    FetchSecureCacheStorageSpy fetchSecureCacheStorage;

    setUp(() async {
      fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
      sut = LocalLoadCurrentAccount(
          fetchSecureCacheStorage: fetchSecureCacheStorage);
    });

    test('should call FetchSecureCacheStorage with correct value', () async {
      await sut.load();

      verify(fetchSecureCacheStorage.fetchSecure('token')).called(1);
    });
  });
}

import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/domain/entities/account_entity.dart';

import 'package:for_dev/domain/usecases/save_current_account.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({@required this.saveSecureCacheStorage});

  @override
  Future<void> save(AccountEntity account) async {
    await saveSecureCacheStorage.saveSecure(key: 'token', value: account.token);
  }
}

abstract class SaveSecureCacheStorage {
  Future<void> saveSecure({
    @required String key,
    @required String value,
  });
}

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

main() {
  group('LocalSaveCurrentAccount', () {
    test('should call SaveCacheStorage with correct values', () async {
      final saveSecureCacheStorage = SaveSecureCacheStorageSpy();
      final sut = LocalSaveCurrentAccount(
          saveSecureCacheStorage: saveSecureCacheStorage);
      final account = AccountEntity(faker.guid.guid());

      await sut.save(account);

      verify(
        saveSecureCacheStorage.saveSecure(
          key: 'token',
          value: account.token,
        ),
      );
    });
  });
}

import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/helpers/helpers.dart';

import 'package:for_dev/data/usecases/usecases.dart';
import 'package:for_dev/data/cache/cache.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

main() {
  group('LocalSaveCurrentAccount', () {
    SaveSecureCacheStorageSpy saveSecureCacheStorage;
    LocalSaveCurrentAccount sut;
    AccountEntity account;

    void mockError() {
      when(
        saveSecureCacheStorage.saveSecure(
          key: anyNamed('key'),
          value: anyNamed('value'),
        ),
      ).thenThrow(
        Exception(),
      );
    }

    setUp(() async {
      saveSecureCacheStorage = SaveSecureCacheStorageSpy();
      sut = LocalSaveCurrentAccount(
          saveSecureCacheStorage: saveSecureCacheStorage);
      account = AccountEntity(faker.guid.guid());
    });

    test('should call SaveSecureCacheStorageSpy with correct values', () async {
      await sut.save(account);

      verify(
        saveSecureCacheStorage.saveSecure(
          key: 'token',
          value: account.token,
        ),
      );
    });

    test('should throw UnexpectedError if SaveSecureCacheStorageSpy throws',
        () async {
      mockError();

      final future = sut.save(account);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}

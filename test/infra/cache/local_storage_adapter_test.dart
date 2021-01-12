import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/data/cache/cache.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({@required this.secureStorage});

  @override
  Future<void> saveSecure(
      {@required String key, @required String value}) async {
    await secureStorage.write(key: key, value: value);
  }
}

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

main() {
  group('LocalStorageAdapter', () {
    test('should call save secure with correct values', () async {
      final key = faker.lorem.word();
      final value = faker.guid.guid();
      final secureStorage = FlutterSecureStorageSpy();
      final sut = LocalStorageAdapter(secureStorage: secureStorage);

      await sut.saveSecure(key: key, value: value);

      verify(secureStorage.write(key: key, value: value));
    });
  });
}

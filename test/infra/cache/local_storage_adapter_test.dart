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
    LocalStorageAdapter sut;
    String key;
    String value;
    FlutterSecureStorageSpy secureStorage;

    void mockSaveSecureError() {
      when(
        secureStorage.write(
          key: anyNamed('key'),
          value: anyNamed('value'),
        ),
      ).thenThrow(Exception());
    }

    setUp(() async {
      key = faker.lorem.word();
      value = faker.guid.guid();
      secureStorage = FlutterSecureStorageSpy();
      sut = LocalStorageAdapter(secureStorage: secureStorage);
    });

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
}

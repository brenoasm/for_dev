import '../../../data/usecases/usecases.dart';

import '../../../domain/usecases/usecases.dart';

import '../../factories/factories.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() {
  return LocalSaveCurrentAccount(
    saveSecureCacheStorage: makeLocalStorageAdapter(),
  );
}

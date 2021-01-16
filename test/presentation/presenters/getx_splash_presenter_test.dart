import 'package:faker/faker.dart';
import 'package:for_dev/domain/entities/account_entity.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/domain/usecases/usecases.dart';
import 'package:for_dev/ui/pages/pages.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({@required this.loadCurrentAccount});

  var _navigateTo = RxString();

  @override
  Future<void> checkAccount() async {
    final account = await loadCurrentAccount.load();

    if (account == null) {
      _navigateTo.value = '/login';
    } else {
      _navigateTo.value = '/surveys';
    }
  }

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

main() {
  group('GetxSplashPresenter', () {
    LoadCurrentAccountSpy loadCurrentAccount;
    GetxSplashPresenter sut;

    void mockLoadCurrentAccount({AccountEntity account}) {
      when(loadCurrentAccount.load()).thenAnswer((_) async => account);
    }

    setUp(() async {
      loadCurrentAccount = LoadCurrentAccountSpy();
      sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
      mockLoadCurrentAccount(account: AccountEntity(faker.guid.guid()));
    });

    test('should call LoadCurrentAccount', () async {
      await sut.checkAccount();

      verify(loadCurrentAccount.load()).called(1);
    });

    test('should go to surveys page on success', () async {
      sut.navigateToStream.listen(
        expectAsync1(
          (page) => expect(page, '/surveys'),
        ),
      );

      await sut.checkAccount();

      verify(loadCurrentAccount.load()).called(1);
    });

    test('should go to login page on null result', () async {
      mockLoadCurrentAccount(account: null);

      sut.navigateToStream.listen(
        expectAsync1(
          (page) => expect(page, '/login'),
        ),
      );

      await sut.checkAccount();

      verify(loadCurrentAccount.load()).called(1);
    });
  });
}

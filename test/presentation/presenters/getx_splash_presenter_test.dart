import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/usecases/usecases.dart';

import 'package:for_dev/presentation/presenters/presenters.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

main() {
  group('GetxSplashPresenter', () {
    LoadCurrentAccountSpy loadCurrentAccount;
    GetxSplashPresenter sut;

    PostExpectation mockLoadCurrentAccountCall() =>
        when(loadCurrentAccount.load());

    void mockLoadCurrentAccount({AccountEntity account}) {
      mockLoadCurrentAccountCall().thenAnswer((_) async => account);
    }

    void mockLoadCurrentAccountError() {
      mockLoadCurrentAccountCall().thenThrow(Exception());
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

    test('should go to login page on error', () async {
      mockLoadCurrentAccountError();

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

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
    await loadCurrentAccount.load();

    _navigateTo.value = '/surveys';
  }

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;
}

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

main() {
  group('GetxSplashPresenter', () {
    LoadCurrentAccountSpy loadCurrentAccount;
    GetxSplashPresenter sut;

    setUp(() async {
      loadCurrentAccount = LoadCurrentAccountSpy();
      sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
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
  });
}

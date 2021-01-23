import 'package:get/state_manager.dart';
import 'package:meta/meta.dart';

import '../../ui/pages/pages.dart';
import '../../domain/usecases/usecases.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({@required this.loadCurrentAccount});

  var _navigateTo = RxString();

  @override
  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));

    try {
      final account = await loadCurrentAccount.load();

      if (account == null) {
        _navigateTo.value = '/login';
      } else {
        _navigateTo.value = '/surveys';
      }
    } catch (e) {
      _navigateTo.value = '/login';
    }
  }

  @override
  Stream<String> get navigateToStream => _navigateTo.stream;
}

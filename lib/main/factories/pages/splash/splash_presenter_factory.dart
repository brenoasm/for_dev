import 'package:for_dev/ui/pages/pages.dart';

import '../../../../presentation/presenters/presenters.dart';

import '../../usecases/usecases.dart';

SplashPresenter makeGetxSplashPresenter() {
  return GetxSplashPresenter(
    loadCurrentAccount: makeLocalLoadCurrentAccount(),
  );
}

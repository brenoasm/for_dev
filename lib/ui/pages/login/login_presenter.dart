import '../../helpers/errors/errors.dart';

abstract class LoginPresenter {
  Stream<UIError> get emailErrorStream;
  Stream<UIError> get passwordErrorStream;
  Stream<UIError> get mainErrorStream;
  Stream<String> get navigateToStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;

  void validateEmail(String value);
  void validatePassword(String value);
  Future<void> auth();
  void dispose();
}

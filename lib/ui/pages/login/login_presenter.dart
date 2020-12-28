abstract class LoginPresenter {
  Stream get emailErrorStream;

  void validateEmail(String value);
  void validatePassword(String value);
}

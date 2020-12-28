abstract class LoginPresenter {
  Stream get emailErrorStream;
  Stream get passwordErrorStream;

  void validateEmail(String value);
  void validatePassword(String value);
}

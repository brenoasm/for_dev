abstract class LoginPresenter {
  Stream get emailErrorStream;
  Stream get passwordErrorStream;
  Stream get isFormValidStream;
  Stream get isLoadingStream;

  void validateEmail(String value);
  void validatePassword(String value);
  void auth();
}

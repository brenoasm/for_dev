import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../protocols/protocols.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/pages/login/login_presenter.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;

  String _email;
  String _password;

  var _emailError = RxString();
  var _passwordError = RxString();
  var _mainError = RxString();
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  Stream<String> get emailErrorStream => _emailError.stream;
  Stream<String> get passwordErrorStream => _passwordError.stream;
  Stream<String> get mainErrorStream => _mainError.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;

  GetxLoginPresenter({
    @required this.validation,
    @required this.authentication,
  });

  void validateEmail(String value) {
    _email = value;
    _emailError.value = validation.validate(field: 'email', value: value);

    _validateForm();
  }

  void validatePassword(String value) {
    _password = value;
    _passwordError.value = validation.validate(field: 'password', value: value);

    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  Future<void> auth() async {
    _isLoading.value = true;

    _validateForm();

    try {
      await authentication.auth(
        AuthenticationParams(email: _email, secret: _password),
      );
    } on DomainError catch (e) {
      _mainError.value = e.description;
    }

    _isLoading.value = false;

    _validateForm();
  }

  void dispose() {}
}

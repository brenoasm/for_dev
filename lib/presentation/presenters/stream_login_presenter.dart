import 'dart:async';

import 'package:meta/meta.dart';

import '../protocols/protocols.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/pages/login/login_presenter.dart';

class LoginState {
  String email;
  String emailError;
  String password;
  String passwordError;
  String mainError;
  bool isLoading = false;

  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
}

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;

  LoginState _state = LoginState();
  var _controller = StreamController<LoginState>.broadcast();

  Stream<String> get emailErrorStream =>
      _controller?.stream?.map((state) => state.emailError)?.distinct();
  Stream<String> get passwordErrorStream =>
      _controller?.stream?.map((state) => state.passwordError)?.distinct();
  Stream<String> get mainErrorStream =>
      _controller?.stream?.map((state) => state.mainError)?.distinct();
  Stream<String> get navigateToStream => throw UnimplementedError();
  Stream<bool> get isFormValidStream =>
      _controller?.stream?.map((state) => state.isFormValid)?.distinct();
  Stream<bool> get isLoadingStream =>
      _controller?.stream?.map((state) => state.isLoading)?.distinct();

  StreamLoginPresenter({
    @required this.validation,
    @required this.authentication,
  });

  void _update() => _controller?.add(_state);

  void validateEmail(String value) {
    _state.email = value;
    _state.emailError = validation.validate(field: 'email', value: value);

    _update();
  }

  void validatePassword(String value) {
    _state.password = value;
    _state.passwordError = validation.validate(field: 'password', value: value);

    _update();
  }

  Future<void> auth() async {
    _state.isLoading = true;

    _update();

    try {
      await authentication.auth(
        AuthenticationParams(email: _state.email, secret: _state.password),
      );
    } on DomainError catch (e) {
      _state.mainError = e.description;
    }

    _state.isLoading = false;

    _update();
  }

  void dispose() {
    _controller.close();
    _controller = null;
  }
}

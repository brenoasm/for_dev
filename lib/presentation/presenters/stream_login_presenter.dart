import 'dart:async';

import 'package:meta/meta.dart';

import '../protocols/protocols.dart';

class LoginState {
  String email;
  String emailError;
  String password;
  String passwordError;

  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
}

class StreamLoginPresenter {
  final Validation validation;

  LoginState _state = LoginState();
  final _controller = StreamController<LoginState>.broadcast();

  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();
  Stream<String> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();
  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  StreamLoginPresenter({@required this.validation});

  void _update() => _controller.add(_state);

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
}

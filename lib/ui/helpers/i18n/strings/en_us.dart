import 'translations.dart';

class EnUs implements Translations {
  @override
  String get msgRequiredField => 'Required field';
  @override
  String get msgInvalidCredentials => 'Invalid credentials.';
  @override
  String get msgInvalidField => 'Invalid field';
  @override
  String get msgUnexpected => 'Unexpected error occurred. Try again later.';

  @override
  String get addAccount => 'Add account';
  @override
  String get email => 'Email';
  @override
  String get enter => 'Enter';
  @override
  String get forDev => '4Dev';
  @override
  String get login => 'Login';
  @override
  String get password => 'Password';
  @override
  String get loading => 'Wait...';
  @override
  String get name => 'Name';
  @override
  String get confirmPassword => 'Confirm password';
}

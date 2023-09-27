import 'package:formz/formz.dart';

/// Validation errors for the [Password] [FormzInput].
enum PasswordValidationError {
  /// Generic invalid error.
  invalid,
  invalidLetterNum,
  invalidLenNumber,
  invalidLenLetter,
  invalidNumber,
  invalidLetter,
  invalidLen,
}

/// {@template password}
/// Form input for an password input.
/// {@endtemplate}
class Password extends FormzInput<String, PasswordValidationError> {
  /// {@macro password}
  const Password.pure() : super.pure('');

  /// {@macro password}
  const Password.dirty([super.value = '']) : super.dirty();

  static final _passwordLetterRegExp = RegExp('[A-Za-z]');
  static final _passwordNumberRegExp = RegExp(r'\d');
  static final _passwordLenghtRegExp = RegExp('.{8,}');

  @override
  PasswordValidationError? validator(String? value) {
    if (!_passwordLenghtRegExp.hasMatch(value ?? '') &&
        !_passwordLetterRegExp.hasMatch(value ?? '') &&
        !_passwordNumberRegExp.hasMatch(value ?? '')) {
      return PasswordValidationError.invalid;
    } else if (_passwordLenghtRegExp.hasMatch(value ?? '') &&
        !_passwordLetterRegExp.hasMatch(value ?? '') &&
        !_passwordNumberRegExp.hasMatch(value ?? '')) {
      return PasswordValidationError.invalidLetterNum;
    } else if (!_passwordLenghtRegExp.hasMatch(value ?? '') &&
        _passwordLetterRegExp.hasMatch(value ?? '') &&
        !_passwordNumberRegExp.hasMatch(value ?? '')) {
      return PasswordValidationError.invalidLenNumber;
    } else if (!_passwordLenghtRegExp.hasMatch(value ?? '') &&
        !_passwordLetterRegExp.hasMatch(value ?? '') &&
        _passwordNumberRegExp.hasMatch(value ?? '')) {
      return PasswordValidationError.invalidLenLetter;
    } else if (_passwordLenghtRegExp.hasMatch(value ?? '') &&
        _passwordLetterRegExp.hasMatch(value ?? '') &&
        !_passwordNumberRegExp.hasMatch(value ?? '')) {
      return PasswordValidationError.invalidNumber;
    } else if (_passwordLenghtRegExp.hasMatch(value ?? '') &&
        !_passwordLetterRegExp.hasMatch(value ?? '') &&
        _passwordNumberRegExp.hasMatch(value ?? '')) {
      return PasswordValidationError.invalidLetter;
    } else if (!_passwordLenghtRegExp.hasMatch(value ?? '') &&
        _passwordLetterRegExp.hasMatch(value ?? '') &&
        _passwordNumberRegExp.hasMatch(value ?? '')) {
      return PasswordValidationError.invalidLen;
    } else {
      return null;
    }
  }
}

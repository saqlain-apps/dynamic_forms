part of '../../validation.dart';

class PasswordValidation extends StringValidation {
  const PasswordValidation({this.passwordChecker, super.strings});

  final RegExp? passwordChecker;

  @override
  ValidationResult validate({required String input}) {
    var passwordCheck =
        passwordChecker ?? ValidationRegex.passwordWithSpecialChar;

    if (input.isEmpty) {
      return ValidationResult(message: strings.emptyPassword);
    }

    if (input.length < 7) {
      return ValidationResult(message: strings.invalidLengthPassword);
    }
    if (input.length > 17) {
      return ValidationResult(message: strings.invalidLengthPassword);
    }

    if (passwordCheck.hasMatch(input)) {
      return const ValidationResult.proper();
    } else {
      return ValidationResult(message: strings.improperPassword);
    }
  }

  ValidationResult repeatValidate(
      {required String input, required String mainPassword}) {
    if (input.isEmpty) {
      return ValidationResult(message: strings.incorrectRepeatPassword);
    }

    if (input == mainPassword) {
      return const ValidationResult.proper();
    } else {
      return ValidationResult(message: strings.incorrectRepeatPassword);
    }
  }
}

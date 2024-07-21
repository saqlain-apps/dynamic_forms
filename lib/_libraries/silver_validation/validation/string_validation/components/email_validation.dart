part of '../../validation.dart';

class EmailValidation extends StringValidation {
  const EmailValidation({this.emailChecker, super.strings});

  final RegExp? emailChecker;

  @override
  ValidationResult validate({required String input}) {
    var emailCheck = emailChecker ?? ValidationRegex.email;

    if (input.isEmpty) {
      return ValidationResult(message: strings.improperEmail);
    }

    if (emailCheck.hasMatch(input)) {
      return const ValidationResult.proper();
    } else {
      return ValidationResult(message: strings.improperEmail);
    }
  }
}

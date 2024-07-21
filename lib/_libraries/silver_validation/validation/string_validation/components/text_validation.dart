part of '../../validation.dart';

class TextValidation extends StringValidation {
  const TextValidation({super.strings});

  @override
  ValidationResult validate({required String input}) {
    if (input.trim().isEmpty) {
      return ValidationResult(message: strings.emptyField);
    }

    if (input.length < 3) {
      return ValidationResult(message: strings.invalidLengthString);
    }

    return const ValidationResult.proper();
  }
}

part of '../../validation.dart';

class USPhoneValidation extends StringValidation {
  const USPhoneValidation({super.strings});

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return ValidationResult(message: strings.emptyField);
    }

    if (!ValidationRegex.usPhoneFilter.hasMatch(input)) {
      return ValidationResult(message: strings.improperPhone);
    }

    return const ValidationResult.proper();
  }
}

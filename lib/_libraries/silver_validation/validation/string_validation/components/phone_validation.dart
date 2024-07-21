part of '../../validation.dart';

class PhoneValidation extends StringValidation {
  const PhoneValidation({super.strings});

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return ValidationResult(message: strings.emptyPhone);
    }
    if (ValidationRegex.inverseNumberOnlyFilter.hasMatch(input)) {
      return ValidationResult(message: strings.improperPhone);
    } else if (input[0] == '0') {
      return ValidationResult(message: strings.improperPhone);
    }

    if (input.length != 10) {
      return ValidationResult(message: strings.improperPhone);
    }
    return const ValidationResult.proper();
  }
}

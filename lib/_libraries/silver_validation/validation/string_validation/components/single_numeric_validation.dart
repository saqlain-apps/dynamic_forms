part of '../../validation.dart';

class SingleNumericValidation extends StringValidation {
  const SingleNumericValidation({super.strings});

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return ValidationResult(message: strings.emptyField);
    }

    if (ValidationRegex.inverseNumberOnlyFilter.hasMatch(input)) {
      return ValidationResult(message: strings.improperSingleNumber);
    }

    return const ValidationResult.proper();
  }
}

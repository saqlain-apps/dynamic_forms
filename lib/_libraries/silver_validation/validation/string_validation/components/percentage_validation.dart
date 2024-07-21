part of '../../validation.dart';

class PercentageValidation extends StringValidation {
  const PercentageValidation({super.strings});

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return ValidationResult(message: strings.emptyField);
    }

    var num = double.tryParse(input);
    if (num == null) {
      return ValidationResult(message: strings.improperPercentage);
    } else if (num > 100) {
      return ValidationResult(message: strings.invalidLengthPercentage);
    } else {
      return const ValidationResult.proper();
    }
  }
}

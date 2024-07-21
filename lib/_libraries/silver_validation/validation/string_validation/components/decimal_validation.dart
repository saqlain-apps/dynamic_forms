part of '../../validation.dart';

class DecimalValidation extends StringValidation {
  const DecimalValidation({super.strings});

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return ValidationResult(message: strings.emptyField);
    }
    var num = double.tryParse(input);
    if (num == null) {
      return ValidationResult(message: strings.improperDecimal);
    } else {
      return const ValidationResult.proper();
    }
  }
}

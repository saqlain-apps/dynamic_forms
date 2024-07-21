part of '../../validation.dart';

class CountryCodeValidation extends StringValidation {
  const CountryCodeValidation({super.strings});

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return ValidationResult(message: strings.emptyField);
    }

    if (input[0] != '+') {
      return ValidationResult(message: strings.improperCountryCodeFirst);
    }

    if (ValidationRegex.inverseNumberOnlyFilter.hasMatch(input.substring(1))) {
      return ValidationResult(message: strings.improperCountryCode);
    }

    if (input.length > 4 || input.length < 2) {
      return ValidationResult(message: strings.improperCountryCode);
    }

    if (input[1] == '0') {
      return ValidationResult(message: strings.improperCountryCode);
    }
    return const ValidationResult.proper();
  }
}

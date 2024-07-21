import '../../_libraries/silver_validation/silver_validation.dart';

class AppValidationStrings extends ValidationStrings {
  const AppValidationStrings();
}

class OtpValidation extends StringValidation {
  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return ValidationResult(message: strings.emptyField);
    }

    if (input.length != 4) {
      return const ValidationResult(message: "Invalid Otp");
    }

    if (ValidationRegex.inverseNumberOnlyFilter.hasMatch(input)) {
      return ValidationResult(message: strings.improperSingleNumber);
    }

    return const ValidationResult.proper();
  }
}

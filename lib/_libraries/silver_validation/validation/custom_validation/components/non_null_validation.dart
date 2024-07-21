part of '../../validation.dart';

class NonNullValidation<T> extends CustomValidation<T> {
  const NonNullValidation({super.strings});

  @override
  ValidationResult validate({required T input}) {
    if (input == null) {
      return ValidationResult(message: strings.nullField);
    } else {
      return const ValidationResult.proper();
    }
  }
}

class NonNullValidationWithMessage<T> extends CustomValidation<T> {
  const NonNullValidationWithMessage({required this.message});

  final String message;

  @override
  ValidationResult validate({required T input}) {
    if (input == null) {
      return ValidationResult(message: message);
    } else {
      return const ValidationResult.proper();
    }
  }
}

part of '../../validation.dart';

class NonEmptyValidation<T> extends CustomValidation<T> {
  const NonEmptyValidation({super.strings});

  @override
  ValidationResult validate({required T input}) {
    if (input == null) {
      return ValidationResult(message: strings.nullField);
    } else if ((input is List || input is String || input is Map) &&
        (input as dynamic).isEmpty) {
      return ValidationResult(message: strings.emptyField);
    } else {
      return const ValidationResult.proper();
    }
  }
}

class NonEmptyValidationWithMessage<T> extends CustomValidation<T> {
  const NonEmptyValidationWithMessage({required this.message});

  final String message;

  @override
  ValidationResult validate({required T input}) {
    if (input == null) {
      return ValidationResult(message: message);
    } else if ((input is List || input is String || input is Map) &&
        (input as dynamic).isEmpty) {
      return ValidationResult(message: message);
    } else {
      return const ValidationResult.proper();
    }
  }
}

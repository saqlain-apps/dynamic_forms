part of '../validation.dart';

abstract class StringValidation extends Validation<String> {
  const StringValidation({super.strings});

  ValidationResult validateNull(String? input) {
    if (input == null) {
      return ValidationResult(message: strings.emptyField);
    } else {
      return validate(input: input);
    }
  }

  @override
  String? validationSimplified(String? input) => validateNull(input).message;

  /// Takes a transformer Method which transforms the validation result
  /// to return specific error messages.\
  /// Validation Result contains current error message and error Type.
  ///
  /// Returns a validation method
  @override
  String? Function(String? input) validationTransformer(
      String? Function(ValidationResult result) transform) {
    String? validationTransformed(String? input) {
      var result = validateNull(input);
      return transform(result);
    }

    return validationTransformed;
  }

  @override
  bool isProper(String? input) => validateNull(input).isProper;
}

part of 'validation.dart';

abstract class BaseValidation<T> {
  const BaseValidation({ValidationStrings? strings})
      : strings = strings ?? const ValidationStrings();

  final ValidationStrings strings;

  ValidationResult validate({required T input});
  String? validationSimplified(T input) => validate(input: input).message;

  /// Takes a transformer Method which transforms the validation result
  /// to return specific error messages.\
  /// Validation Result contains current error message and error Type.
  ///
  /// Returns a validation method
  String? Function(T input) validationTransformer(
      String? Function(ValidationResult result) transform) {
    String? validationTransformed(T input) {
      var result = validate(input: input);
      return transform(result);
    }

    return validationTransformed;
  }

  bool isProper(T input) => validate(input: input).isProper;
}

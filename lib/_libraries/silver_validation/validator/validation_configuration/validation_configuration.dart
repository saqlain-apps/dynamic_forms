part of '../validator.dart';

class ValidationConfiguration<
    T extends BaseValidator<dynamic, Validation<dynamic>>> {
  late final T validator;

  void _init(T validator) {
    this.validator = validator;
  }

  void configureAutoValidation() {
    validator.autoValidate();
    validator.listenable.addListener(validator.autoValidate);
  }

  void autoValidate() {
    if (validator.validationMode.isEnabled) {
      validator.validate(validator.validationMode);
    }
  }

  ValidationError? transform(
    ValidationResult error,
    ValidationMode mode,
  ) {
    if (error.isProper) {
      return ValidationError(
        errorState: const CorrectValidationState(),
        validationResult: error,
      );
    } else if (error.message!.isEmpty) {
      return const ValidationError.empty();
    } else {
      return null;
    }
  }
}

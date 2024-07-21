part of 'validator.dart';

abstract class ValidationMode {
  const ValidationMode();

  /// Represents how actively data should be validated.
  /// Values should range from 0 to 1.
  /// with 1 being complete validation
  /// and 0 being no validation.
  double get validationFactor;

  ValidationError transformError(ValidationResult result);
}

class NoValidationMode extends ValidationMode {
  const NoValidationMode();

  @override
  double get validationFactor => -1;

  @override
  ValidationError transformError(ValidationResult result) =>
      const ValidationError.empty();
}

class InactiveValidationMode extends ValidationMode {
  const InactiveValidationMode();

  @override
  double get validationFactor => 0;

  @override
  ValidationError transformError(ValidationResult result) {
    return ValidationError(
      errorState: const EmptyValidationState(),
      validationResult: result,
    );
  }
}

class PassiveValidationMode extends ValidationMode {
  const PassiveValidationMode();

  @override
  double get validationFactor => 0.5;

  @override
  ValidationError transformError(ValidationResult result) {
    return ValidationError(
      errorState: const CustomValidationState(.5),
      validationResult: result,
    );
  }
}

class ActiveValidationMode extends ValidationMode {
  const ActiveValidationMode();

  @override
  double get validationFactor => 1;

  @override
  ValidationError transformError(ValidationResult result) {
    return ValidationError(
      errorState: const ErrorValidationState(),
      validationResult: result,
    );
  }
}

extension ValidationModeTypes on ValidationMode {
  bool get isDisabled => validationFactor < 0;
  bool get isEnabled => validationFactor >= 0;
}

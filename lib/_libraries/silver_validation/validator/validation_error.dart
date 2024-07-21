part of 'validator.dart';

class ValidationError {
  const ValidationError({
    required this.errorState,
    required this.validationResult,
  });

  const ValidationError.empty()
      : errorState = const EmptyValidationState(),
        validationResult = const ValidationResult.empty();

  final ValidationState errorState;
  final ValidationResult validationResult;

  String? get errorString {
    return errorState.isError ? validationResult.message : null;
  }

  bool get isCorrect => errorState.incorrectFactor == 0;

  ValidationState merge(List<ValidationError> states) {
    return ValidationState.merge(states.map((e) => e.errorState));
  }

  @override
  String toString() => '$errorState: $validationResult';
}

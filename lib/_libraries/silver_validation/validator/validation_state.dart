part of 'validator.dart';

abstract class ValidationState {
  const ValidationState();

  /// Represents how incorrect the state is.
  /// Values should range from 0 to 1.
  /// with 1 being error and 0 being correct.
  double get incorrectFactor;

  @override
  int get hashCode => incorrectFactor.hashCode;

  @override
  bool operator ==(covariant ValidationState other) =>
      incorrectFactor == other.incorrectFactor;

  static ValidationState merge(Iterable<ValidationState> states) {
    return states.reduce((value, element) =>
        value.incorrectFactor > element.incorrectFactor ? value : element);
  }
}

class CorrectValidationState extends ValidationState {
  const CorrectValidationState();

  @override
  double get incorrectFactor => 0;
}

class ErrorValidationState extends ValidationState {
  const ErrorValidationState();

  @override
  double get incorrectFactor => 1;
}

class EmptyValidationState extends ValidationState {
  const EmptyValidationState();

  @override
  double get incorrectFactor => -1;
}

class CustomValidationState extends ValidationState {
  const CustomValidationState(this.incorrectFactor);

  @override
  final double incorrectFactor;
}

extension ErrorStateChecks on ValidationState {
  /// Undefined, or outside range
  bool get isEmpty => incorrectFactor < 0 || incorrectFactor > 1;

  /// Is Properly Validated
  bool get isCorrect => incorrectFactor == 0;

  /// Has Validation Error
  bool get isIncorrect => incorrectFactor > 0 && incorrectFactor <= 1;

  /// Can show Error
  bool get isError => incorrectFactor == 1;
}

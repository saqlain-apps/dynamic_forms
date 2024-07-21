part of '../validation.dart';

typedef StringValidationLogic = ValidationResult Function(
    String input, ValidationStrings strings);
typedef ValidationLogic<T> = ValidationResult Function(
    T input, ValidationStrings strings);

class ValidationResult {
  const ValidationResult.proper()
      : message = null,
        validationData = null;

  const ValidationResult.empty()
      : message = '',
        validationData = null;

  const ValidationResult({
    required String this.message,
    this.validationData,
  });

  const ValidationResult._internal({
    required this.message,
    this.validationData,
  });

  final String? message;
  final dynamic validationData;

  bool get isProper => message == null;

  ValidationResult copyWith({
    String? message,
    dynamic validationData,
  }) {
    return ValidationResult._internal(
      message: message ?? this.message,
      validationData: validationData ?? this.validationData,
    );
  }

  @override
  String toString() => '$message';
}

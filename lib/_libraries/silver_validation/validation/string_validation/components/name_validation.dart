part of '../../validation.dart';

class NameValidation extends StringValidation {
  const NameValidation({super.strings});

  @override
  ValidationResult validate({required String input}) {
    if (input.isEmpty) {
      return isEmptyResult;
    }

    if (input.length < 3) {
      return isImproperResult;
    }

    if (ValidationRegex.inverseAlphabetSpaceFilter.hasMatch(input)) {
      return isImproperResult;
    }

    return const ValidationResult.proper();
  }

  ValidationResult get isEmptyResult =>
      ValidationResult(message: strings.emptyField);

  ValidationResult get isImproperResult =>
      ValidationResult(message: strings.improperName);
}

class FirstNameValidator extends NameValidation {
  const FirstNameValidator({super.strings});
  @override
  ValidationResult get isEmptyResult =>
      ValidationResult(message: strings.emptyFirstName);

  @override
  ValidationResult get isImproperResult =>
      ValidationResult(message: strings.invalidFirstName);
}

class LastNameValidator extends NameValidation {
  const LastNameValidator({super.strings});

  @override
  ValidationResult get isEmptyResult =>
      ValidationResult(message: strings.emptyLastName);

  @override
  ValidationResult get isImproperResult =>
      ValidationResult(message: strings.invalidLastName);
}

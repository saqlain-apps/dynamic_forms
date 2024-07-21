part of '../validator.dart';

class NotEmptyValidationConfiguration<T extends ValidatedController>
    extends ValidationConfiguration<T> {
  @override
  void autoValidate() {
    if (validator.validationMode.isEnabled && validator.text.isNotEmpty) {
      validator.validate(validator.validationMode);
    }
  }
}

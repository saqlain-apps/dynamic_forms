part of '../validator.dart';

class FocusValidationConfiguration<T extends ValidatedController>
    extends StepValidationConfiguration<T> {
  @override
  void configureAutoValidation() {
    validator.controller.addListener(autoValidate);
    validator.focusNode.addListener(autoValidate);
  }

  @override
  void autoValidate() {
    if (validator.validationMode.isEnabled) {
      if (validator.text.isNotEmpty) {
        final updatedMode = validator.focusNode.hasFocus
            ? const PassiveValidationMode()
            : const ActiveValidationMode();
        validator.updateValidationMode(updatedMode);
        validator.validate(updatedMode);
      }
    }
  }
}

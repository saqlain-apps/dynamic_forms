part of '../../validator.dart';

base class RepeatPasswordValidatedController
    extends ValidatedController<PasswordValidation> {
  factory RepeatPasswordValidatedController.focused({
    required ValidatedController<PasswordValidation> mainPasswordController,
    ValidationMode? validationMode,
    String? initialText,
    FocusNode? focusNode,
  }) {
    return RepeatPasswordValidatedController(
      mainPasswordController: mainPasswordController,
      validationMode: validationMode,
      initialText: initialText,
      focusNode: focusNode,
      configuration: FocusValidationConfiguration(),
    );
  }

  factory RepeatPasswordValidatedController.notEmpty({
    required ValidatedController<PasswordValidation> mainPasswordController,
    ValidationMode? validationMode,
    String? initialText,
    FocusNode? focusNode,
  }) {
    return RepeatPasswordValidatedController(
      mainPasswordController: mainPasswordController,
      validationMode: validationMode,
      initialText: initialText,
      focusNode: focusNode,
      configuration: NotEmptyValidationConfiguration(),
    );
  }

  RepeatPasswordValidatedController({
    required this.mainPasswordController,
    super.initialText,
    super.validationMode,
    super.focusNode,
    super.configuration,
  }) : super(validation: mainPasswordController.validation);

  final ValidatedController<PasswordValidation> mainPasswordController;

  @override
  void _configureAutoValidation() {
    super._configureAutoValidation();
    mainPasswordController.listenable.addListener(autoValidate);
  }

  @override
  ValidationError validate([ValidationMode? mode]) {
    var result = validation.repeatValidate(
      input: value,
      mainPassword: mainPasswordController.text,
    );
    return _processResult(result, mode);
  }
}

part of '../validator.dart';

/// Wrapper class for [TextEditingController]\
/// with internal validation logic
///
/// Use [errorDataStream] to read errors
base class ValidatedController<T extends StringValidation>
    extends BaseValidator<String, T> {
  factory ValidatedController.focused({
    required T validation,
    ValidationMode? validationMode,
    String? initialText,
    FocusNode? focusNode,
  }) {
    return ValidatedController(
      validation: validation,
      validationMode: validationMode,
      initialText: initialText,
      focusNode: focusNode,
      configuration: FocusValidationConfiguration(),
    );
  }

  factory ValidatedController.notEmpty({
    required T validation,
    ValidationMode? validationMode,
    String? initialText,
    FocusNode? focusNode,
  }) {
    return ValidatedController(
      validation: validation,
      validationMode: validationMode,
      initialText: initialText,
      focusNode: focusNode,
      configuration: NotEmptyValidationConfiguration(),
    );
  }

  ValidatedController({
    required super.validation,
    super.validationMode,
    String? initialText,
    FocusNode? focusNode,
    super.configuration,
  })  : controller = TextEditingController(text: initialText),
        focusNode = focusNode ?? FocusNode();

  // Initial State
  //----------------------------------------------------------------------------

  final TextEditingController controller;

  String get text => controller.text;
  set text(String text) => controller.text = text;

  void clear() {
    controller.clear();
    _errorSink.add(const ValidationError.empty());
  }

  @override
  String get value => text;

  @override
  set value(String text) => controller.text = text;

  @override
  ValueListenable<String> get listenable =>
      ProxyListenable(controller, (value) => value.text);

  final FocusNode focusNode;
  //----------------------------------------------------------------------------

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

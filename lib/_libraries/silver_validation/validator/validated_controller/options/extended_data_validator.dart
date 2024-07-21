part of '../../validator.dart';

base class ExtendedValidatedController<S extends StringValidation, T>
    extends ValidatedController<S> {
  factory ExtendedValidatedController.focused({
    required S validation,
    ValidationMode? validationMode,
    String? initialText,
    FocusNode? focusNode,
    T? initialExtendedData,
  }) {
    return ExtendedValidatedController(
      validation: validation,
      validationMode: validationMode,
      initialText: initialText,
      focusNode: focusNode,
      initialExtendedData: initialExtendedData,
      configuration: FocusValidationConfiguration(),
    );
  }

  factory ExtendedValidatedController.notEmpty(
      {required S validation,
      ValidationMode? validationMode,
      String? initialText,
      FocusNode? focusNode,
      T? initialExtendedData}) {
    return ExtendedValidatedController(
      validation: validation,
      validationMode: validationMode,
      initialText: initialText,
      focusNode: focusNode,
      initialExtendedData: initialExtendedData,
      configuration: NotEmptyValidationConfiguration(),
    );
  }

  ExtendedValidatedController({
    required super.validation,
    super.validationMode,
    super.initialText,
    super.focusNode,
    T? initialExtendedData,
    super.configuration,
  }) : _extendedData = initialExtendedData;

  T? _extendedData;
  T? get extendedData => _extendedData;
  set extendedData(T? value) {
    _extendedData = value;
    controller.text = controller.text;
  }
}

part of '../validator.dart';

abstract base class BaseValidator<T, Q extends Validation<T>> {
  BaseValidator({
    required this.validation,
    ValidationMode? validationMode,
    ValidationConfiguration? configuration,
  })  : _validationMode = validationMode ?? const ActiveValidationMode(),
        _configuration = configuration ?? ValidationConfiguration() {
    _init();
  }

  // Initial State
  //----------------------------------------------------------------------------
  final Q validation;
  T get value;
  set value(T value);
  ValueListenable<T> get listenable;

  ValidationMode _validationMode;
  ValidationMode get validationMode => _validationMode;

  final ValidationConfiguration _configuration;
  //----------------------------------------------------------------------------

  // Validation Stream Section
  //----------------------------------------------------------------------------
  final StateStreamController<ValidationError> _errorController =
      StateStreamController.broadcast(
    initialValue: const ValidationError.empty(),
    sync: true,
  );
  Stream<ValidationError> get errorDataStream => _errorController.stream;
  Sink<ValidationError> get _errorSink => _errorController.sink;

  ValidationError get error => _errorController.value;
  //----------------------------------------------------------------------------

  // Validation Init Section
  //----------------------------------------------------------------------------
  void _init() {
    _configuration._init(this);
    _configureAutoValidation();
  }

  void _configureAutoValidation() {
    _configuration.configureAutoValidation();
  }

  void autoValidate() {
    _configuration.autoValidate();
  }
  //----------------------------------------------------------------------------

  // Validation Processing Section
  //----------------------------------------------------------------------------
  ValidationError validate([ValidationMode? mode]) {
    var result = validation.validate(input: value);
    return _processResult(result, mode);
  }

  ValidationError _processResult(ValidationResult result,
      [ValidationMode? mode]) {
    var error = _transform(result, mode ?? validationMode);
    _errorSink.add(error);
    return error;
  }

  ValidationError _transform(
    ValidationResult error,
    ValidationMode mode,
  ) {
    return _configuration.transform(error, mode) ??
        _transformError(error, mode);
  }

  ValidationError _transformError(
          ValidationResult error, ValidationMode mode) =>
      mode.transformError(error);

  void updateValidationMode(ValidationMode mode) {
    _validationMode = mode;
  }
  //----------------------------------------------------------------------------

  void dispose() {
    _errorController.close();
  }
}

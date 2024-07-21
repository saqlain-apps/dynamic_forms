import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../silver_validation.dart';

class ValidatedBuilder extends StatefulWidget {
  static ValidationState validation(List<BaseValidator> validations) {
    return ValidationState.merge(validations.map((e) => e.error.errorState));
  }

  static ValidationState validate(
    List<BaseValidator> validations, [
    ValidationMode? status,
  ]) {
    ValidationState error = const CorrectValidationState();
    for (var controller in validations) {
      var innerError = controller.validate(status);
      error = ValidationState.merge([error, innerError.errorState]);
    }
    return error;
  }

  const ValidatedBuilder({
    required this.validations,
    required this.builder,
    super.key,
  });

  final List<BaseValidator> validations;
  final Widget Function(
    BuildContext context,
    ValidationState error,
    ValidationState Function() validate,
  ) builder;

  @override
  State<ValidatedBuilder> createState() => _ValidatedBuilderState();
}

class _ValidatedBuilderState extends State<ValidatedBuilder> {
  late final StreamGroup<ValidationError> _errorStream;

  bool get noValidation => widget.validations.isEmpty;
  bool get multipleValidation => widget.validations.length > 1;

  @override
  void initState() {
    super.initState();
    _errorStream = StreamGroup();
    addNew(widget);
  }

  @override
  void didUpdateWidget(covariant ValidatedBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    removeOld(oldWidget);
    addNew(widget);
  }

  void addNew(ValidatedBuilder widget) {
    for (var controller in widget.validations) {
      _errorStream.add(controller.errorDataStream);
    }
  }

  void removeOld(ValidatedBuilder oldWidget) {
    for (var oldController in oldWidget.validations) {
      _errorStream.remove(oldController.errorDataStream);
    }
  }

  @override
  void dispose() {
    _errorStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (noValidation) {
      return widget.builder(
        context,
        const EmptyValidationState(),
        () => const EmptyValidationState(),
      );
    } else {
      return StreamBuilder<ValidationError>(
        initialData: const ValidationError.empty(),
        stream: _errorStream.stream,
        builder: (context, snapshot) {
          var validation = ValidatedBuilder.validation(widget.validations);
          ValidationState validate() {
            return ValidatedBuilder.validate(
              widget.validations,
              const ActiveValidationMode(),
            );
          }

          return widget.builder(context, validation, validate);
        },
      );
    }
  }
}

part of '../validator.dart';

base class CustomValidator<T> extends BaseValidator<T, CustomValidation<T>> {
  CustomValidator({
    required super.validation,
    required T initialData,
    super.validationMode,
    super.configuration,
  }) : controller = ValueNotifier(initialData);

  //----------------------------------------------------------------------------
  final ValueNotifier<T> controller;

  @override
  T get value => controller.value;

  @override
  set value(T value) => controller.value = value;

  @override
  ValueListenable<T> get listenable => controller;
  //----------------------------------------------------------------------------

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

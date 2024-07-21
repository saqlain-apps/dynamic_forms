part of '../validation.dart';

class CustomValidations {
  const CustomValidations._internal();

  CustomValidation<T> nonNull<T>({ValidationStrings? strings}) =>
      NonNullValidation(strings: strings);
  CustomValidation<T> nonNullWithMessage<T>({required String message}) =>
      NonNullValidationWithMessage(message: message);

  CustomValidation<T> nonEmpty<T>({ValidationStrings? strings}) =>
      NonNullValidation(strings: strings);
  CustomValidation<T> nonEmptyWithMessage<T>({required String message}) =>
      NonEmptyValidationWithMessage(message: message);

  CustomValidation<T> custom<T>({
    required ValidationLogic<T> logic,
    ValidationStrings? strings,
  }) =>
      CustomLogicValidation(logic: logic, strings: strings);
}

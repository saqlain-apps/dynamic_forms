part of '../../validation.dart';

class CustomLogicValidation<T> extends CustomValidation<T> {
  const CustomLogicValidation({required this.logic, super.strings});

  final ValidationLogic<T> logic;

  @override
  ValidationResult validate({required T input}) => logic(input, strings);
}

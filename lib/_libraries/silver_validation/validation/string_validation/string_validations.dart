part of '../validation.dart';

class StringValidations {
  const StringValidations._internal();

  StringValidation email({RegExp? emailChecker, ValidationStrings? strings}) =>
      EmailValidation(emailChecker: emailChecker, strings: strings);
  PasswordValidation password(
          {RegExp? passwordChecker, ValidationStrings? strings}) =>
      PasswordValidation(passwordChecker: passwordChecker, strings: strings);
  StringValidation custom(StringValidationLogic logic,
          {ValidationStrings? strings}) =>
      CustomStringValidation(logic: logic, strings: strings);

  StringValidation countryCode({ValidationStrings? strings}) =>
      CountryCodeValidation(strings: strings);
  StringValidation name({ValidationStrings? strings}) =>
      NameValidation(strings: strings);
  StringValidation text({ValidationStrings? strings}) =>
      TextValidation(strings: strings);
  StringValidation percentage({ValidationStrings? strings}) =>
      PercentageValidation(strings: strings);
  StringValidation numeric({ValidationStrings? strings}) =>
      SingleNumericValidation(strings: strings);
  StringValidation decimal({ValidationStrings? strings}) =>
      DecimalValidation(strings: strings);
  StringValidation phone({ValidationStrings? strings}) =>
      PhoneValidation(strings: strings);
  StringValidation firstName({ValidationStrings? strings}) =>
      FirstNameValidator(strings: strings);
  StringValidation lastName({ValidationStrings? strings}) =>
      LastNameValidator(strings: strings);
  StringValidation usPhone({ValidationStrings? strings}) =>
      USPhoneValidation(strings: strings);
  StringValidation alwaysProper() => const AlwaysProperValidation();
  StringValidation none() => const NoneValidation();
}

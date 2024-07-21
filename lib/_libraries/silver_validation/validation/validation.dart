library silver_validation;

import '/utils/app_helpers/app_validation.dart';

part 'base_validation.dart';
part 'custom_validation/components/custom_logic_validation.dart';
part 'custom_validation/components/non_empty_validation.dart';
part 'custom_validation/components/non_null_validation.dart';
part 'custom_validation/custom_validation.dart';
part 'custom_validation/custom_validations.dart';
part 'string_validation/components/always_proper_validation.dart';
part 'string_validation/components/country_code_validation.dart';
part 'string_validation/components/custom_string_validation.dart';
part 'string_validation/components/decimal_validation.dart';
part 'string_validation/components/email_validation.dart';
part 'string_validation/components/name_validation.dart';
part 'string_validation/components/none_validation.dart';
part 'string_validation/components/password_validation.dart';
part 'string_validation/components/percentage_validation.dart';
part 'string_validation/components/phone_validation.dart';
part 'string_validation/components/single_numeric_validation.dart';
part 'string_validation/components/text_validation.dart';
part 'string_validation/components/us_phone_validation.dart';
part 'string_validation/string_validation.dart';
part 'string_validation/string_validations.dart';
part 'validation_result/validation_result.dart';
part 'validation_utils/validation_regex.dart';
part 'validation_utils/validation_strings.dart';

abstract class Validation<T> extends BaseValidation<T> {
  const Validation({ValidationStrings? strings})
      : super(strings: strings ?? defaultStrings);

  static const ValidationStrings defaultStrings = AppValidationStrings();

  static StringValidations get string => const StringValidations._internal();
  static CustomValidations get custom => const CustomValidations._internal();
}

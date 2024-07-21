part of '../_src.dart';

class RawValidatedTextField extends RawTextField {
  RawValidatedTextField({
    required ValidatedController? controller,
    super.border,
    super.contentPadding,
    super.enabled,
    super.fillColor,
    super.focusedBorder,
    super.hint,
    super.inputAction,
    super.inputFormatters,
    super.keyboardType,
    super.label,
    super.maxLength,
    super.maxLines = 1,
    super.style,
    super.suffixIcon,
    super.obscureText,
    super.obscuringCharacter,
    this.showErrorText = true,
    super.key,
  })  : validatedController = controller,
        super(
          controller: controller?.controller,
          focusNode: controller?.focusNode,
        );

  final ValidatedController? validatedController;
  final bool showErrorText;

  @override
  Widget build(BuildContext context) {
    return buildValidator(context);
  }

  Widget buildValidator(BuildContext context) {
    return ValidationBuilder(
      controller: validatedController,
      builder: buildValidation,
    );
  }

  Widget buildValidation(BuildContext context, ValidationError error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildErrorTextField(context, error),
        if (showErrorText) TextFieldError(error)
      ],
    );
  }

  CustomTextField buildErrorTextField(
      BuildContext context, ValidationError error) {
    var field = buildTextField(context);
    final hasError = error.errorState.isError;
    if (hasError) {
      field = field.copyWith(
        style: (style ?? AppStyles.of(context).label).colored(AppColors.red),
        decoration: field.decoration?.copyWith(
          error: const SizedBox.shrink(),
        ),
      );
    }

    return field;
  }
}

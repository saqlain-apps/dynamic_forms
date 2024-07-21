part of '../_src.dart';

mixin _PasswordFieldMixin on RawTextField {
  Widget buildVisibilitySwitch(
    BuildContext context,
    CustomTextField textField, [
    Color? visibilityColor,
  ]) {
    return ValueTransitionedBuilder<bool>(
      initialValue: false,
      builder: (context, value, _, update, child) {
        final isPasswordVisible = value;
        final switchPasswordVisibility = update;
        textField = textField.copyWith(
          obscureText: !isPasswordVisible,
          decoration: textField.decoration?.copyWith(
            suffixIcon: _TextFieldPasswordVisibilitySwitch(
              isPasswordVisible: isPasswordVisible,
              visibilityColor: visibilityColor,
              onSwitch: () => switchPasswordVisibility(!isPasswordVisible),
            ),
          ),
        );
        return textField;
      },
    );
  }
}

class ValidatedPasswordField extends RawValidatedTextField
    with _PasswordFieldMixin {
  ValidatedPasswordField({
    required super.controller,
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
    super.obscuringCharacter,
    super.showErrorText = true,
    super.key,
  });

  @override
  Widget buildValidation(BuildContext context, ValidationError error) {
    final hasError = error.errorState.isError;
    final color = hasError ? AppColors.red : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildVisibilitySwitch(
          context,
          buildErrorTextField(context, error),
          color,
        ),
        if (showErrorText) TextFieldError(error)
      ],
    );
  }
}

class PasswordField extends RawTextField with _PasswordFieldMixin {
  const PasswordField({
    required super.controller,
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
    super.obscuringCharacter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return buildVisibilitySwitch(context, buildTextField(context));
  }
}

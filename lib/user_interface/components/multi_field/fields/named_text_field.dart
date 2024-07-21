part of '../_src.dart';

mixin _NamedFieldMixin on RawTextField {
  String? get name;

  Widget buildNamedField(BuildContext context, Widget textField) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isNotBlank(name))
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(name!, style: AppStyles.of(context).label),
          ),
        Flexible(child: textField),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildNamedField(context, super.build(context));
  }
}

class NamedTextField extends AppTextField with _NamedFieldMixin {
  const NamedTextField({
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
    this.name,
    super.style,
    super.suffixIcon,
    super.obscureText,
    super.obscuringCharacter,
    super.key,
  });

  @override
  final String? name;
}

class NamedPasswordField extends PasswordField with _NamedFieldMixin {
  const NamedPasswordField({
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
    this.name,
    super.style,
    super.obscuringCharacter,
    super.key,
  });

  @override
  final String? name;
}

part of '../_src.dart';

class RawTextField extends StatelessWidget {
  static final Radius radius = Radius.circular(10.r);

  static BorderSide defaultBorderSide = const BorderSide(color: AppColors.grey);
  static BorderSide focusedBorderSide(BorderSide side) =>
      side.copyWith(width: 2);
  static BorderSide errorBorderSide(BorderSide side) =>
      side.copyWith(color: AppColors.red);

  static final InputBorder defaultInputBorder = OutlineInputBorder(
    borderSide: defaultBorderSide,
    borderRadius: BorderRadius.all(radius),
  );
  static InputBorder effectiveFocusedBorder(InputBorder border) =>
      border.copyWith(borderSide: focusedBorderSide(border.borderSide));
  static InputBorder errorBorder(InputBorder border) =>
      border.copyWith(borderSide: errorBorderSide(border.borderSide));

  const RawTextField({
    required this.controller,
    this.border,
    this.contentPadding,
    this.enabled,
    this.fillColor,
    this.focusedBorder,
    this.focusNode,
    this.hint,
    this.inputAction,
    this.inputFormatters,
    this.keyboardType,
    this.label,
    this.floatingLabelBehavior,
    this.maxLength,
    this.maxLines = 1,
    this.style,
    this.suffixIcon,
    this.obscureText,
    this.obscuringCharacter,
    this.onSubmitted,
    this.onEditingComplete,
    super.key,
  });

  final InputBorder? border;
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? enabled;
  final Color? fillColor;
  final InputBorder? focusedBorder;
  final String? hint;
  final TextInputAction? inputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? label;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final int? maxLength;
  final int? maxLines;
  final TextStyle? style;
  final Widget? suffixIcon;
  final bool? obscureText;
  final String? obscuringCharacter;
  final void Function(String)? onSubmitted;
  final void Function()? onEditingComplete;

  InputBorder get effectiveBorder => border ?? defaultInputBorder;

  @override
  Widget build(BuildContext context) {
    return buildTextField(context);
  }

  CustomTextField buildTextField(BuildContext context) {
    return CustomTextField(
      controller: controller,
      enabled: enabled,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType ?? TextInputType.text,
      focusNode: focusNode,
      maxLength: maxLength,
      maxLines: maxLines,
      style: style ?? AppStyles.of(context).label,
      textInputAction: inputAction ?? TextInputAction.next,
      obscuringCharacter: obscuringCharacter ?? '•',
      obscureText: obscureText ?? false,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              vertical: 2.h,
              horizontal: 12.w,
            ),
        counter: maxLength != null ? nothing : null,
        hintText: hint,
        hintStyle: AppStyles.of(context).label.colored(AppColors.grey),
        filled: true,
        fillColor: fillColor ?? AppColors.white.withOpacity(.7),
        labelStyle: AppStyles.of(context).label,
        labelText: label,
        floatingLabelBehavior: floatingLabelBehavior,
        suffixIcon: suffixIcon,
        border: effectiveBorder,
        enabledBorder: effectiveBorder,
        focusedBorder: focusedBorder ?? effectiveFocusedBorder(effectiveBorder),
        focusedErrorBorder: effectiveFocusedBorder(
            errorBorder(focusedBorder ?? effectiveBorder)),
        errorBorder: errorBorder(effectiveBorder),
      ),
    );
  }
}

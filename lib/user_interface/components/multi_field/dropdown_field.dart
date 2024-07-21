part of '_src.dart';

class DropdownField<T> extends StatelessWidget {
  const DropdownField({
    required this.items,
    this.value,
    this.hint,
    this.selectedItemBuilder,
    this.fillColor,
    this.onChanged,
    super.key,
  });

  final String? hint;

  final Color? fillColor;

  final Widget Function(BuildContext context, T? value)? selectedItemBuilder;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T? value)? onChanged;

  InputBorder get border => RawTextField.defaultInputBorder;
  InputBorder get focusedBorder => RawTextField.effectiveFocusedBorder(border);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      alignment: Alignment.centerLeft,
      value: value,
      icon: const RotatedBox(
        quarterTurns: 1,
        child: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
        ),
      ),
      elevation: 8,
      style: AppStyles.of(context).sMedium,
      selectedItemBuilder: selectedItemBuilder != null
          ? (context) =>
              items.map((e) => selectedItemBuilder!(context, e.value)).toList()
          : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        border: border,
        focusedBorder: focusedBorder,
        enabledBorder: border,
        fillColor: fillColor ?? AppColors.white.withOpacity(.7),
        filled: true,
      ),
      onChanged: onChanged,
      isExpanded: true,
      hint: hint == null
          ? null
          : FittedBox(
              child: Text(
                hint!,
                style: AppStyles.of(context).sMedium.colored(Colors.grey),
              ),
            ),
      items: items,
    );
  }

  static List<DropdownMenuItem<T>> defaultItemBuilder<T>(
      List<T> items, String Function(T value) convertor) {
    return items
        .map((e) => DropdownMenuItem(value: e, child: Text(convertor(e))))
        .toList();
  }
}

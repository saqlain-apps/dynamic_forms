import 'package:flutter/services.dart';

class RevertFilteringTextInputFormatter extends FilteringTextInputFormatter {
  RevertFilteringTextInputFormatter(super.filterPattern,
      {required super.allow});
  RevertFilteringTextInputFormatter.allow(super.filterPattern)
      : super(allow: true);
  RevertFilteringTextInputFormatter.deny(super.filterPattern)
      : super(allow: false);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final finalized = super.formatEditUpdate(oldValue, newValue);
    if (newValue.text.isNotEmpty && finalized.text.isEmpty) {
      return oldValue;
    }

    return finalized;
  }
}

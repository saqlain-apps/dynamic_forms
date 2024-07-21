part of '../_src.dart';

class SearchTextField extends RawTextField with _AppTextFieldMixin {
  SearchTextField({
    required TextEditingController super.controller,
    super.border,
    super.contentPadding,
    super.enabled,
    super.fillColor,
    super.focusedBorder,
    super.hint,
    super.inputFormatters,
    super.keyboardType,
    super.label,
    super.maxLength,
    super.maxLines = 1,
    super.style,
    super.obscureText,
    super.obscuringCharacter,
    super.onSubmitted,
    super.onEditingComplete,
    super.focusNode,
    super.key,
  }) : super(
            inputAction: TextInputAction.search,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    if (controller.text.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            controller.clear();
                          },
                          borderRadius: BorderRadius.circular(99),
                          child: Icon(
                            Icons.close,
                            size: 30.r,
                            color: AppColors.grey,
                          ),
                        ),
                      );
                    } else {
                      return Icon(
                        Icons.search,
                        size: 30.sp,
                        color: AppColors.grey,
                      );
                    }
                  },
                ),
                const Gap(12),
              ],
            ));
}

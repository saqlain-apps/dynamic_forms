part of '_src.dart';

class WidgetField extends StatelessWidget {
  static BoxBorder defaultBorder =
      Border.fromBorderSide(RawTextField.defaultBorderSide);

  const WidgetField({
    this.fillColor,
    this.padding,
    this.border,
    this.child,
    super.key,
  });

  final EdgeInsets? padding;
  final Color? fillColor;
  final BoxBorder? border;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: border,
        borderRadius: BorderRadius.circular(8.r),
        color: fillColor ?? AppColors.white.withOpacity(.7),
      ),
      child: Row(children: [
        Expanded(child: child ?? const SizedBox(height: 24)),
      ]),
    );
  }

  static Widget buildText(String text) {
    return Builder(builder: (context) {
      return Text(
        text,
        style: AppStyles.of(context).sMedium.colored(Colors.grey),
      );
    });
  }

  static Widget buildHint(String hint) {
    return Builder(builder: (context) {
      return Text(
        hint,
        style: AppStyles.of(context).sMedium.colored(Colors.grey),
      );
    });
  }

  static Widget buildDropDown({required Widget child}) {
    return Builder(builder: (context) {
      return Row(
        children: [
          Expanded(child: child),
          const RotatedBox(
            quarterTurns: 1,
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ),
        ],
      );
    });
  }

  static Widget buildDropDownWithHint(String hint) {
    return buildDropDown(child: buildHint(hint));
  }
}

part of '../_src.dart';

class TextFieldError extends StatelessWidget {
  const TextFieldError(this.error, {super.key});

  final ValidationError error;

  @override
  Widget build(BuildContext context) {
    if (error.errorString != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          error.errorString!,
          style: AppStyles.of(context).error,
          key: const ValueKey('Error String'),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _TextFieldPasswordVisibilitySwitch extends StatelessWidget {
  const _TextFieldPasswordVisibilitySwitch({
    required this.onSwitch,
    this.visibilityColor,
    this.isPasswordVisible = false,
  });

  final Color? visibilityColor;
  final bool isPasswordVisible;
  final VoidCallback onSwitch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, top: 15),
      child: InkWell(
          onTap: onSwitch,
          child: Text(
            isPasswordVisible ? "HIDE" : "SHOW",
            style:
                AppStyles.of(context).sSmall.wSemiBold.colored(visibilityColor),
          )),
    );
  }
}

// ignore: unused_element
class TextFieldErrorIndicator extends StatelessWidget {
  const TextFieldErrorIndicator(this.error, {super.key});

  final ValidationError error;

  @override
  Widget build(BuildContext context) {
    if (!error.errorState.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Icon(
          error.errorState.isCorrect ? Icons.done : Icons.close,
          color: AppColors.black,
          key: const ValueKey('Error Indicator'),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

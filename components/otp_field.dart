import 'package:flutter/services.dart';
import 'package:jaktiv/utils/app_helpers/_app_helper_import.dart';
import 'package:jaktiv/utils/silver_validation/silver_validation.dart';
import 'package:pinput/pinput.dart';

class OtpField extends StatelessWidget {
  const OtpField(this.controller, {super.key});

  final ValidatedController controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ValidatorError>(
      initialData: const ValidatorError.empty(),
      stream: controller.errorDataStream,
      builder: (context, snapshot) {
        var error = snapshot.data!;
        return Pinput(
          focusNode: controller.focusNode,
          controller: controller.controller,
          listenForMultipleSmsOnAndroid: true,
          autofocus: true,
          length: 4,
          errorText: error.errorString,
          errorBuilder: (errorText, pin) {
            return Center(
              child: Text(
                errorText!,
                style: AppStyles.of(context).error,
              ),
            );
          },
          errorTextStyle: AppStyles.of(context).error,
          forceErrorState: error.errorState.isIncorrect,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          errorPinTheme: errorPin(context),
          submittedPinTheme: focusedPin(context),
          focusedPinTheme: focusedPin(context),
          defaultPinTheme: defaultPin(context),
          separatorBuilder: (index) => const SizedBox(width: 8),
          hapticFeedbackType: HapticFeedbackType.lightImpact,
        );
      },
    );
  }

  PinTheme defaultPin(BuildContext context) {
    return PinTheme(
      width: 46,
      height: 46,
      textStyle: AppStyles.of(context).buttonText,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.of(context).disabled!),
      ),
    );
  }

  PinTheme focusedPin(BuildContext context) {
    return defaultPin(context).copyBorderWith(
      border: Border.all(color: AppColors.of(context).secondary!),
    );
  }

  PinTheme errorPin(BuildContext context) {
    return defaultPin(context).copyBorderWith(
      border: Border.all(color: AppColors.of(context).incorrect!),
    );
  }
}

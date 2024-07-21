import '/global/snackbars/messages/snackbar_message.dart';
import '/utils/app_helpers/_app_helper_import.dart';

class InfoSnackBarMessage extends SnackBarMessage<String> {
  const InfoSnackBarMessage(super.messenger);

  @override
  SnackBar build({
    required String message,
    Duration duration = const Duration(milliseconds: 3000),
    Widget? action,
  }) {
    return SnackBar(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.zero,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Builder(builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      message,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: AppStyles.of(context).wSemiBold,
                    ),
                  ],
                );
              }),
            ),
            if (action != null) action,
          ],
        ),
      ),
    );
  }
}

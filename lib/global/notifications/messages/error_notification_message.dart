import '/utils/app_helpers/_app_helper_import.dart';
import 'notification_message.dart';

class ErrorNotificationMessage extends NotificationMessage<String> {
  const ErrorNotificationMessage(super.messenger);

  @override
  Widget buildNotification(String message) {
    return Builder(builder: (context) {
      return SafeArea(
        child: Material(
          child: Container(
            constraints:
                BoxConstraints(minHeight: 60.h, minWidth: double.infinity),
            margin: EdgeInsets.symmetric(horizontal: 18.w),
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColors.red,
            ),
            child: Flex(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              direction: Axis.vertical,
              children: [
                Flexible(
                  child: Text(
                    message,
                    maxLines: 12,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.of(context).wSemiBold.cWhite,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

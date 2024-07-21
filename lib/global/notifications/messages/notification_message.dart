import '/utils/app_helpers/_app_helper_import.dart';
import '../notification_messenger.dart';

abstract class NotificationMessage<T> {
  const NotificationMessage(this.messenger);
  final NotificationMessenger messenger;

  void show(T message) {
    printMessages(message);
    messenger.push(
      (animation) => buildAnimation(
        animation,
        buildNotification(message),
      ),
    );
  }

  Widget buildAnimation(Animation<double> animation, Widget child) {
    animation = CurvedAnimation(parent: animation, curve: Curves.ease);
    child = FadeTransition(opacity: animation, child: child);

    return Builder(builder: (context) {
      var position = MediaQuery.of(context).viewPadding;
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return buildPosition(context, position, animation, child!);
        },
        child: child,
      );
    });
  }

  Widget buildPosition(
    BuildContext context,
    EdgeInsets padding,
    Animation<double> animation,
    Widget child,
  ) {
    var tween = Tween<double>(begin: 0, end: padding.top);
    padding = padding.copyWith(top: tween.evaluate(animation));
    return Positioned(
      top: padding.top,
      bottom: padding.bottom,
      left: padding.left,
      right: padding.right,
      child: Align(
        alignment: Alignment.topLeft,
        child: child,
      ),
    );
  }

  Widget buildNotification(T message);
}

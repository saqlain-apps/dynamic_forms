import 'package:flutter/foundation.dart';

import '/utils/app_helpers/_app_helper_import.dart';

/// For Debugging Purposes Only
class DevBox extends StatelessWidget {
  const DevBox({
    this.child,
    this.color = Colors.amber,
    this.width = 1,
    this.layout = true,
    super.key,
  });

  final Widget? child;
  final Color color;
  final double width;
  final bool layout;

  @override
  Widget build(BuildContext context) {
    if (!kReleaseMode) {
      return layout ? layoutHandler(container()) : container();
    } else {
      return child ?? const SizedBox.shrink();
    }
  }

  Widget container() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: width),
      ),
      child: child,
    );
  }

  Widget layoutHandler(Widget child) {
    return LayoutBuilder(builder: (context, constraints) {
      printPersistent(constraints);
      return child;
    });
  }
}

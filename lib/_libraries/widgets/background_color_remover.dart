import 'package:flutter/material.dart';

class BackgroundColorRemover extends StatelessWidget {
  const BackgroundColorRemover({this.child, super.key});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    var result = (child ?? const SizedBox.shrink());

    if (Theme.of(context).scaffoldBackgroundColor.opacity != 0) {
      result = Theme(
        data: Theme.of(context)
            .copyWith(scaffoldBackgroundColor: Colors.transparent),
        child: result,
      );
    }
    return result;
  }
}

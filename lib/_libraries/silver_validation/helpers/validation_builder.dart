import 'package:flutter/material.dart';

import '../silver_validation.dart';

class ValidationBuilder extends StatelessWidget {
  const ValidationBuilder({
    required this.builder,
    this.controller,
    super.key,
  });

  final BaseValidator? controller;
  final Widget Function(BuildContext context, ValidationError error) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ValidationError>(
      stream: controller?.errorDataStream,
      initialData: controller?.error ?? const ValidationError.empty(),
      builder: (context, snapshot) => builder(context, snapshot.data!),
    );
  }
}

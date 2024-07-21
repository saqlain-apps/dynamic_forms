import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_state.dart';

class BlocView<T extends StateStreamable<Q>, Q extends BlocState>
    extends StatelessWidget {
  const BlocView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<T>();
    return BlocConsumer<T, Q>(
      builder: (context, state) {
        return buildContent(context, state, controller);
      },
      listenWhen: (previous, current) =>
          previous.event != current.event || previous.status != current.status,
      listener: (context, state) {
        blocListener(context, state, controller);
      },
    );
  }

  Widget buildContent(BuildContext context, Q state, T controller) {
    return const Placeholder();
  }

  void blocListener(BuildContext context, Q state, T controller) {
    if (state.status.isSuccess) {
      // Success
    } else if (state.status.isFailed) {
      // Failed
    }
  }
}

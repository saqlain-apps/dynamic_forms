import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/_libraries/bloc/bloc_view.dart';
import '/controllers/<name>/<name>_controller.dart';


class <Name>Screen extends BlocView<<Name>Controller, <Name>State> {
  static Widget get provider {
    return BlocProvider(
      create: (context) => <Name>Controller(),
      child: const <Name>Screen(),
    );
  }

  const <Name>Screen({super.key});

  @override
  void blocListener(
    BuildContext context,
    <Name>State state,
    <Name>Controller controller,
  ) {
    if (state.status.isSuccess) {
      // Success
    } else if (state.status.isFailed) {
      // Failed
      var failureMessage = state.message;
      if (isNotBlank(failureMessage)) {
        Messenger().notificationMessenger.errorMessage.show(failureMessage!);
      }
    }
  }

  @override
  Widget buildContent(
    BuildContext context,
    <Name>State state,
    <Name>Controller controller,
  ) {
    return const Placeholder();
  }
}

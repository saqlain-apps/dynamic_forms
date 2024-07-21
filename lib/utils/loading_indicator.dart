import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingIndicator {
  Completer? _futureCompleter;

  void show(
    BuildContext context, [
    Widget Function(BuildContext context) builder = _defaultLoader,
  ]) {
    _futureCompleter = Completer();
    showLoading(
      context: context,
      future: _futureCompleter!.future,
      builder: builder,
    );
  }

  void dismiss() {
    if (_futureCompleter != null) {
      _futureCompleter!.complete();
    }
  }

  Future<void> showLoading({
    required BuildContext context,
    required Future future,
    required Widget Function(BuildContext context) builder,
    void Function(BuildContext context)? pop,
  }) async {
    BuildContext dialogContext = context;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        dialogContext = context;

        var useBackButtonListener =
            Router.maybeOf(context)?.backButtonDispatcher != null;

        return useBackButtonListener
            ? BackButtonListener(
                child: builder(context),
                onBackButtonPressed: () async => true,
              )
            : PopScope(
                canPop: false,
                child: builder(context),
              );
      },
    );

    await future;
    if (dialogContext.mounted) {
      (pop ?? Navigator.of(context).pop)();
    }
  }

  static Widget _defaultLoader(BuildContext context) =>
      loadingContainer(defaultIndicator());

  static Widget loadingContainer(Widget indicator) {
    return Center(
      child: Builder(builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).hoverColor.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: indicator,
        );
      }),
    );
  }

  static Widget defaultIndicator([Color color = Colors.white]) {
    return CircularProgressIndicator(color: color);
  }

  static Widget cupertinoIndicator([Color color = Colors.white]) {
    return CupertinoActivityIndicator(
      animating: true,
      color: color,
      radius: 30,
    );
  }
}

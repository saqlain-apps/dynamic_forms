import 'package:flutter/material.dart';

class Scoped<T> extends InheritedWidget {
  const Scoped({
    required super.child,
    required this.state,
    required this.shouldNotify,
    super.key,
  });

  const Scoped.notify({
    required super.child,
    required this.state,
    super.key,
  }) : shouldNotify = _defaultShouldNotify;

  const Scoped.static({
    required super.child,
    required this.state,
    super.key,
  }) : shouldNotify = _defaultShouldNotNotify;

  final T state;
  final bool Function(Scoped<T> oldScope) shouldNotify;

  @override
  bool updateShouldNotify(covariant Scoped<T> oldWidget) =>
      shouldNotify(oldWidget);

  static bool _defaultShouldNotify<T>(Scoped<T> oldWidget) => true;
  static bool _defaultShouldNotNotify<T>(Scoped<T> oldWidget) => false;

  static T? maybeOf<T>(BuildContext context) {
    var scope = context.dependOnInheritedWidgetOfExactType<Scoped<T>>();
    return scope?.state;
  }

  static T? maybeOfStatic<T>(BuildContext context) {
    var scope = context.findAncestorWidgetOfExactType<Scoped<T>>();
    return scope?.state;
  }

  static T? maybeOfStaticRoot<T>(BuildContext context) {
    Scoped<T>? scope;

    context.visitAncestorElements(
      (element) {
        if (element.widget.runtimeType == Scoped<T>) {
          scope = element.widget as Scoped<T>;
        }
        return true;
      },
    );

    return scope?.state;
  }
}

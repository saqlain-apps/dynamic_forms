// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

class SilverCapsule<T> extends SingleChildStatefulWidget {
  const SilverCapsule({
    required this.create,
    this.lazy = true,
    this.listener,
    this.dispose,
    super.child,
    super.key,
  });

  final bool lazy;
  final T Function(BuildContext context) create;
  final void Function() Function(T capsule, void Function() notify)? listener;
  final void Function(T capsule)? dispose;

  @override
  SingleChildState<SilverCapsule<T>> createState() => _SilverCapsuleState<T>();

  static T of<T>(BuildContext context) {
    final result = _CapsuleScope.maybeOf<T>(context);
    assert(result != null, 'No Capsule<$T> found in context');
    return result!.capsule(context);
  }

  static T ofStatic<T>(BuildContext context) {
    final result = _CapsuleScope.maybeOfStatic<T>(context);
    assert(result != null, 'No Capsule<$T> found in context');
    return result!.capsule(context);
  }
}

class _SilverCapsuleState<T> extends SingleChildState<SilverCapsule<T>> {
  void Function()? _removeListener;

  T? _capsule;
  T capsule(BuildContext context) {
    if (_capsule == null) {
      _capsule = widget.create(context);
      _removeListener = widget.listener?.call(_capsule as T, rebuild);
    }
    return _capsule!;
  }

  @override
  void dispose() {
    _removeListener?.call();
    if (_capsule != null && widget.dispose != null) {
      widget.dispose!(_capsule as T);
    }
    super.dispose();
  }

  void rebuild() => setState(() {});

  bool get _shouldNotify => _capsule != null;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    if (_capsule == null && !widget.lazy) capsule(context);
    return _CapsuleScope<T>(
      owner: this,
      child: child ?? const SizedBox.shrink(),
    );
  }
}

class _CapsuleScope<T> extends InheritedWidget {
  const _CapsuleScope({
    required _SilverCapsuleState<T> owner,
    required super.child,
    super.key,
  }) : _owner = owner;

  final _SilverCapsuleState<T> _owner;

  T capsule(BuildContext context) {
    return _owner.capsule(context);
  }

  @override
  bool updateShouldNotify(covariant _CapsuleScope oldWidget) =>
      _owner._shouldNotify;

  static _CapsuleScope<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CapsuleScope<T>>();
  }

  static _CapsuleScope<T>? maybeOfStatic<T>(BuildContext context) {
    return context.findAncestorWidgetOfExactType<_CapsuleScope<T>>();
  }
}

class MultiCapsule extends Nested {
  MultiCapsule({
    required List<SingleChildWidget> capsules,
    TransitionBuilder? builder,
    Widget? child,
    super.key,
  }) : super(
          children: capsules,
          child: builder != null
              ? Builder(builder: (context) => builder(context, child))
              : child,
        );
}

extension CapsuleFinder on BuildContext {
  T findCapsule<T>() => SilverCapsule.ofStatic(this);
  T observeCapsule<T>() => SilverCapsule.of(this);
}

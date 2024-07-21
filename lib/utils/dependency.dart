import 'dart:async';

import 'package:get_it/get_it.dart';

class DependencyHandler {
  const DependencyHandler({required List<Dependency> dependencies})
      : _dependencies = dependencies;

  final List<Dependency> _dependencies;

  FutureOr<void> registerDependencies() async {
    for (var dep in _dependencies) {
      await dep.register();
    }
  }

  void unregisterDependencies() {
    for (var dep in _dependencies) {
      dep.unregister();
    }
  }
}

abstract class Dependency<T extends Object> {
  Dependency._internal();

  factory Dependency.value({
    required T value,
    void Function(T element)? dispose,
  }) {
    return FixedDependencyElement(
      value: value,
      dispose: dispose,
    );
  }

  factory Dependency({
    required FutureOr<T> Function() create,
    void Function(T element)? dispose,
  }) {
    return DynamicDependencyElement(
      create: create,
      dispose: dispose,
    );
  }

  void Function(T element)? get dispose;

  FutureOr<T> _create();
  T? _element;

  FutureOr<void> register() async {
    _element = await _create();
    GetIt.I.registerSingleton<T>(_element!);
    return null;
  }

  void unregister() {
    GetIt.I.unregister<T>();
    dispose?.call(_element!);
    _element = null;
  }
}

class FixedDependencyElement<T extends Object> extends Dependency<T> {
  FixedDependencyElement({
    required this.value,
    this.dispose,
  }) : super._internal();

  final T value;

  @override
  T _create() => value;

  @override
  final void Function(T element)? dispose;
}

class DynamicDependencyElement<T extends Object> extends Dependency<T> {
  DynamicDependencyElement({
    required this.create,
    this.dispose,
  }) : super._internal();

  FutureOr<T> Function() create;

  @override
  FutureOr<T> _create() => create();

  @override
  final void Function(T element)? dispose;
}

import 'package:flutter/foundation.dart';

class ProxyListenable<T, Q> implements ValueListenable<T> {
  const ProxyListenable(this.original, this.converter);

  final ValueListenable<Q> original;
  final T Function(Q value) converter;

  @override
  void addListener(VoidCallback listener) => original.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      original.removeListener(listener);

  @override
  T get value => converter(original.value);
}

class ProxyNotifer<T, Q> implements ValueNotifier<T> {
  const ProxyNotifer({
    required this.original,
    required this.converter,
    required this.reverser,
  });

  final ValueNotifier<Q> original;
  final T Function(Q value) converter;
  final Q Function(T value) reverser;

  @override
  T get value => converter(original.value);

  @override
  set value(T value) {
    original.value = reverser(value);
  }

  @override
  void addListener(VoidCallback listener) {
    original.addListener(listener);
  }

  @override
  void dispose() {
    original.dispose();
  }

  @override
  bool get hasListeners => original.hasListeners;

  @override
  void notifyListeners() {
    original.notifyListeners();
  }

  @override
  void removeListener(VoidCallback listener) {
    original.removeListener(listener);
  }
}

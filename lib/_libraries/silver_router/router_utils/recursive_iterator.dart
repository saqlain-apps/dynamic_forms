part of '../silver_router_delegate.dart';

class RecursiveIterator<E> {
  final Iterable<E> _iterable;
  final int _length;
  int _index;
  E? _current;
  E? _lastAvailable;

  RecursiveIterator(Iterable<E> iterable)
      : _iterable = iterable,
        _length = iterable.length,
        _index = 0;

  E? get current => _current;
  E? get lastAvailable => _lastAvailable;

  @pragma("vm:prefer-inline")
  bool moveNext() => _move(() => _index++);

  @pragma("vm:prefer-inline")
  bool movePrevious() => _move(() => _index--);

  @pragma("vm:prefer-inline")
  bool _move(void Function() indexModification) {
    int length = _iterable.length;
    if (_length != length) {
      throw ConcurrentModificationError(_iterable);
    }

    if (_index < 0 || _index >= length) {
      _current = null;
      return false;
    }

    _current = _iterable.elementAt(_index);
    _lastAvailable = _current;
    indexModification();
    return true;
  }
}

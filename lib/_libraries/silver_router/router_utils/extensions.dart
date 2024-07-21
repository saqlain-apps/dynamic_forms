part of '../silver_router_delegate.dart';

extension _Find<E> on Iterable<E> {
  E? findWhere(bool Function(E element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }

    return null;
  }
}

extension _Replace<E> on List<E> {
  void replaceWhere(bool Function(E element) test, E newElement) {
    var oldElement = findWhere(test);
    if (oldElement != null) {
      replaceElement(oldElement, newElement);
    }
  }

  List<E> replaceElementAt(int index, E element) {
    replaceRange(index, index + 1, [element]);
    return this;
  }

  List<E> replaceElement(E oldElement, E newElement) {
    return replaceElementAt(indexOf(oldElement), newElement);
  }
}

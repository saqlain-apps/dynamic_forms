import '/utils/app_helpers/extensions.dart';
import '../_libraries/bloc/bloc_event.dart';

mixin BlocRepository<T, Q> {
  Q identify(T item);
  bool compare(T a, T b) => identify(a) == identify(b);

  BlocRepositoryState<T, Q> get repo;

  BlocRepositoryState<T, Q> addHandler(BlocRepositoryAddEvent<T> event) {
    return repo.updateWith(
      event: event,
      dataSet: update(repo.dataSet, event.items),
      sections: updateIdentifiers(
        original: repo.sections,
        keys: event.keys,
        identifiers: event.items.map((e) => identify(e)).toSet(),
        index: event.index ?? -1,
        reset: event.reset,
      ),
    );
  }

  BlocRepositoryState<T, Q> updateHandler(
      BlocRepositoryUpdateEvent<T, Q> event) {
    final isRemoving = event.item == null;
    return repo.updateWith(
      event: event,
      sections: isRemoving
          ? removeIdentifiers(repo.sections, {event.identifier})
          : null,
      dataSet: updateSingle(
        repo.dataSet,
        event.identifier,
        event.item,
      ),
    );
  }

  BlocRepositoryState<T, Q> clearHandler(BlocRepositoryClearEvent event) {
    return repo.updateWith(event: event, sections: {}, dataSet: {});
  }

  Map<Q, T> update(
    Map<Q, T> original,
    List<T> replacement,
  ) {
    return updateRaw(original, repo.identify, replacement);
  }

  Map<Y, X> updateRaw<X, Y>(
    Map<Y, X> original,
    Y Function(X item) identify,
    List<X> replacement,
  ) {
    return Map<Y, X>.from(original)
      ..addEntries(replacement.map((e) => MapEntry(identify(e), e)));
  }

  Map<Q, T> updateSingle(
    Map<Q, T> original,
    Q identifier,
    T? replacement,
  ) {
    return updateSingleRaw(
      original,
      repo.identify,
      identifier,
      replacement,
    );
  }

  Map<Y, X> updateSingleRaw<X, Y>(
    Map<Y, X> original,
    Y Function(X item) identify,
    Y identifier,
    X? replacement,
  ) {
    var updated = Map<Y, X>.from(original)..remove(identifier);
    if (replacement != null) {
      updated = updateRaw(updated, identify, [replacement]);
    }
    return Map.unmodifiable(updated);
  }

  Map<String, Set<Q>> updateIdentifiers({
    required Map<String, Set<Q>> original,
    required Set<String> keys,
    required Set<Q> identifiers,
    required int index,
    required bool reset,
  }) {
    final updated = Map<String, Set<Q>>.from(original);
    if (reset) {
      for (var key in keys) {
        updated[key] = Set.unmodifiable({});
      }
    }

    for (var key in keys) {
      var idSet = updated[key] ?? {};
      if (index < 0) index = idSet.length;
      idSet = (idSet.toList()..insertAll(index, identifiers)).toSet();

      updated[key] = Set.unmodifiable(idSet);
    }

    return Map.unmodifiable(updated);
  }

  Map<String, Set<Q>> removeIdentifiers(
    Map<String, Set<Q>> original,
    Set<Q> identifiers,
  ) {
    var updated = Map<String, Set<Q>>.from(original);
    updated = updated.map(
        (key, value) => MapEntry(key, value.toSet()..removeAll(identifiers)));
    return Map.unmodifiable(updated);
  }
}

class IdentifiedObject<T, Q> {
  final Q identifer;
  final T item;
  const IdentifiedObject({required this.identifer, required this.item});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IdentifiedObject<T, Q> && other.identifer == identifer;
  }

  @override
  int get hashCode => identifer.hashCode;
}

mixin BlocRepositoryState<T, Q> {
  Map<Q, T> get dataSet;
  List<T> get storedData => dataSet.values.toList();
  Map<String, Set<Q>> get sections;

  Set<IdentifiedObject<X, Y>> identifyData<X, Y>(
    Iterable<X> data,
    Y Function(X item) identify,
  ) =>
      data
          .map((e) => IdentifiedObject(identifer: identify(e), item: e))
          .toSet();

  Q identify(T item);
  bool compare(T a, T b) => identify(a) == identify(b);

  T? dataById(Q identifier) {
    return dataSet[identifier];
  }

  List<T> dataByIds(Set<Q> identifiers) {
    return identifiers.map((e) => dataSet[e]).whereNotNull.toList();
  }

  List<T> dataByKey(String key) {
    return dataByIds(sections[key] ?? {});
  }

  BlocRepositoryState<T, Q> updateWith({
    required BlocEvent event,
    Map<Q, T>? dataSet,
    Map<String, Set<Q>>? sections,
  });
}

mixin BlocRepositoryAddEvent<T> on BlocEvent {
  Set<String> get keys;
  List<T> get items;
  int? get index;
  bool get reset;
}

mixin BlocRepositoryUpdateEvent<T, Q> on BlocEvent {
  Q get identifier;
  T? get item;
}

mixin BlocRepositoryClearEvent on BlocEvent {}

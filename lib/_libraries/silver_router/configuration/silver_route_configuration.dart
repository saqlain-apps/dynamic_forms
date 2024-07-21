part of '../silver_router_delegate.dart';

class SilverRouteConfiguration {
  factory SilverRouteConfiguration.copy(SilverRouteConfiguration config) =>
      SilverRouteConfiguration(history: config.history.toList());

  SilverRouteConfiguration({required List<SilverRoute> history})
      : _history = List.unmodifiable(history.toList());

  final List<SilverRoute> _history;
  List<SilverRoute> get history => _history.toList();
  bool get isEmpty => _history.isEmpty;

  SilverRouteConfiguration copyWith({List<SilverRoute>? history}) {
    return SilverRouteConfiguration(history: history ?? this.history);
  }

  @override
  String toString() => history.toString();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SilverRouteConfiguration &&
        listEquals(other._history, _history);
  }

  @override
  int get hashCode => _history.hashCode;
}

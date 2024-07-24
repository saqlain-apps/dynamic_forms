part of 'home_controller.dart';

sealed class HomeEvent extends BlocEvent {
  const HomeEvent();
}

class HomeInitialEvent extends HomeEvent {
  const HomeInitialEvent();
}

class HomeSyncEvent extends HomeEvent {
  const HomeSyncEvent(this.appState);
  final AppState appState;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeSyncEvent;
  }

  @override
  int get hashCode => hash("HomeSyncEvent");
}

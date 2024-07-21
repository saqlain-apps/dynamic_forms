part of 'base_controller.dart';

sealed class BaseEvent extends BlocEvent {
  const BaseEvent();
}

class BaseInitialEvent extends BaseEvent {
  const BaseInitialEvent();
}

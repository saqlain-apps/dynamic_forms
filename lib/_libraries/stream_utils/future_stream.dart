part of 'state_stream.dart';

/// Must Call Dispose\
/// Only Broadcast Streams
class FutureStream<T> extends StateStream<T> {
  FutureStream({
    super.initialValue,
    required this.getData,
    required super.stream,
  });

  FutureStream.unobserved({
    super.initialValue,
    required this.getData,
    required super.stream,
  }) : super.unobserved();

  final FutureOr<T> Function() getData;

  FutureOr<T> fetchValue() async {
    if (value is T) return value as T;
    _value = await getData();
    return value as T;
  }

  @override
  void observe() {
    super.observe();
    fetchValue();
  }
}

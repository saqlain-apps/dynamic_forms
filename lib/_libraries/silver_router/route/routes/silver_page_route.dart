part of '../../silver_router_delegate.dart';

class SilverPageRoute extends SilverRoute {
  SilverPageRoute({
    required this.name,
    required this.builder,
    this.argumentEncoder,
    this.argumentDecoder,
    this.routeTransition,
    this.pageKey,
    this.argument,
  });

  @override
  final String name;

  @override
  final dynamic argument;
  final Function(String? argument)? argumentDecoder;
  final String? Function(dynamic argument)? argumentEncoder;

  @override
  final RouteTransitionsBuilder? routeTransition;

  final Widget Function(BuildContext context, dynamic argument) builder;

  final String? pageKey;

  @override
  Widget screen(BuildContext context) => builder(context, argument);

  @override
  String? encodeArgument(argument) =>
      argumentEncoder?.call(argument) ?? super.encodeArgument(argument);

  @override
  decodeArgument(String? argument) =>
      argumentDecoder?.call(argument) ?? super.decodeArgument(argument);

  @override
  String get keyInfo => pageKey ?? super.keyInfo;

  @override
  SilverPageRoute copyWith({
    dynamic argument,
    RouteTransitionsBuilder? routeTransition,
  }) {
    return SilverPageRoute(
      name: name,
      builder: builder,
      pageKey: pageKey,
      argumentDecoder: argumentDecoder,
      argumentEncoder: argumentEncoder,
      argument: argument ?? this.argument,
      routeTransition: routeTransition ?? this.routeTransition,
    );
  }
}

extension RouteMethods<T> on SilverRoute {
  SilverRoute withArgument(dynamic argument) => copyWith(argument: argument);
}

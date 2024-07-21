part of '../../silver_router_delegate.dart';

class SilverBranchedRoute extends SilverRouteProxy {
  SilverBranchedRoute({
    required List<SilverRoute> branches,
    this.routeIndexBuilder = defaultRouteIndexBuilder,
    required this.builder,
    required String initialRoute,
    dynamic argument,
  })  : assert(branches.isNotEmpty),
        branches = List.unmodifiable(branches) {
    currentIndex = routeIndexBuilder(initialRoute, argument, branches);
  }

  SilverBranchedRoute._internal({
    required List<SilverRoute> branches,
    required this.routeIndexBuilder,
    required this.builder,
    required this.currentIndex,
  }) : branches = List.unmodifiable(branches);

  final List<SilverRoute> branches;

  @override
  SilverRoute get proxyRoute => branches[currentIndex];

  late final int currentIndex;

  final int Function(
    String name,
    dynamic argument,
    List<SilverRoute> branches,
  ) routeIndexBuilder;

  final Widget Function(
    BuildContext context,
    int index,
    dynamic argument,
    Widget shell,
  ) builder;

  @override
  String get debugName =>
      '${proxyRoute.debugName}:${branches.map((e) => e.debugName).toSet()}';

  @override
  bool identifyName(String name) => branches.any((e) => e.identifyName(name));

  @override
  FutureOr<SilverRoute> parse(
    BuildContext context,
    String urlInfo, [
    SilverRouteProxy? proxy,
  ]) async {
    var obj = proxy ?? this;
    final urlData = obj.decodeUrlInfo(urlInfo);
    final argument = await obj.decodeArgument(urlData.$2);
    final name = urlData.$1;

    // Nested Branched Route is not yet supported
    if (proxy != null) {
      return proxy.copyRootWith<SilverBranchedRoute>(
        (proxy.rootProxy<SilverBranchedRoute>() as SilverBranchedRoute)
            .copyWith(name: name, argument: argument),
      );
    } else {
      return copyWith(name: name, argument: argument);
    }
  }

  @override
  Widget screen(BuildContext context) {
    return builder(
      context,
      currentIndex,
      argument,
      IndexedStack(
        index: currentIndex,
        children: branches.map((e) => e.screen(context)).toList(),
      ),
    );
  }

  @override
  SilverBranchedRoute copyWith({
    String? name,
    dynamic argument,
    SilverRoute? proxyRoute,
    List<SilverRoute>? branches,
  }) {
    int index = currentIndex;
    var updatedBranches = branches ?? this.branches;

    if (name != null) {
      index = routeIndexBuilder(name, argument, updatedBranches);
    }

    if (argument != null) {
      updatedBranches = updatedBranches.replaceElementAt(
        index,
        updatedBranches[index].copyWith(argument: argument),
      );
    }

    if (proxyRoute != null) {
      updatedBranches = updatedBranches.replaceElementAt(index, proxyRoute);
    }

    return SilverBranchedRoute._internal(
      branches: updatedBranches,
      routeIndexBuilder: routeIndexBuilder,
      builder: builder,
      currentIndex: index,
    );
  }

  static int defaultRouteIndexBuilder(
    String name,
    dynamic argument,
    List<SilverRoute> branches,
  ) {
    return branches.indexWhere((e) => e.identifyName(name));
  }
}

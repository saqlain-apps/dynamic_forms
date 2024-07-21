part of '../silver_router_delegate.dart';

// ignore: must_be_immutable
abstract class SilverRawPage<T> extends Page<T> {
  static Widget noTransitionBuilder(
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) =>
      child;

  SilverRawPage({
    required this.pageBuilder,
    super.name,
    super.arguments,
    this.transitionsBuilder,
    this.transitionDuration,
    this.reverseTransitionDuration,
    this.maintainState = true,
    this.fullscreenDialog = false,
    super.restorationId,
    super.key,
  });

  final RoutePageBuilder pageBuilder;
  final RouteTransitionsBuilder? transitionsBuilder;

  final bool maintainState;
  final bool fullscreenDialog;

  final Duration? transitionDuration;
  final Duration? reverseTransitionDuration;

  bool didPop(T? result) => true;
  Future<T?>? get popped async {
    await Future.delayed(Durations.short1);
    return await _pageRoute?.popped;
  }

  SilverRawPageRoute<T>? _pageRoute;

  @override
  Route<T> createRoute(BuildContext context) {
    _pageRoute = SilverRawPageRoute<T>(page: this);
    return _pageRoute!;
  }
}

class SilverRawPageRoute<T> extends PageRoute<T> {
  Widget adaptiveTransition(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (kIsWeb) {
      return SilverRawPage.noTransitionBuilder(
          context, animation, secondaryAnimation, child);
    }

    final PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;
    return theme.buildTransitions<T>(
        this, context, animation, secondaryAnimation, child);
  }

  SilverRawPageRoute({required SilverRawPage<T> page}) : super(settings: page);

  SilverRawPage<T> get _page => settings as SilverRawPage<T>;

  @protected
  Widget buildContent(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _page.pageBuilder(context, animation, secondaryAnimation);
  }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return (nextRoute is PageRoute && !nextRoute.fullscreenDialog);
  }

  @override
  bool didPop(T? result) {
    return _page.didPop(result) ? super.didPop(result) : false;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget result = buildContent(context, animation, secondaryAnimation);
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final builder = _page.transitionsBuilder ?? adaptiveTransition;
    return builder(context, animation, secondaryAnimation, child);
  }

  @override
  Duration get transitionDuration =>
      _page.transitionDuration ?? const Duration(milliseconds: 300);

  @override
  Duration get reverseTransitionDuration =>
      _page.reverseTransitionDuration ?? super.reverseTransitionDuration;

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';
}

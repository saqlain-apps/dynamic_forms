import '/utils/app_helpers/_app_helper_import.dart';

class RemoteDataBuilder<T> extends StatelessWidget {
  factory RemoteDataBuilder.sliver({
    required T? data,
    required bool isLoading,
    required Widget Function(BuildContext context, T data) builder,
    String? failureMessage,
  }) {
    return RemoteDataBuilder(
      data: data,
      isLoading: isLoading,
      builder: builder,
      loadingIndicator: sliverLoadingIndicator,
      failureBuilder: (context) =>
          sliverFailureBuilder(context, text: failureMessage),
    );
  }

  factory RemoteDataBuilder.sliverCenter({
    required T? data,
    required bool isLoading,
    required Widget Function(BuildContext context, T data) builder,
    String? failureMessage,
  }) {
    return RemoteDataBuilder(
      data: data,
      isLoading: isLoading,
      builder: builder,
      loadingIndicator: sliverCenterLoadingIndicator,
      failureBuilder: (context) =>
          sliverCenterFailureBuilder(context, text: failureMessage),
    );
  }

  factory RemoteDataBuilder.box({
    required T? data,
    required bool isLoading,
    required Widget Function(BuildContext context, T data) builder,
    String? failureMessage,
  }) {
    return RemoteDataBuilder(
      data: data,
      isLoading: isLoading,
      builder: builder,
      loadingIndicator: defaultLoadingIndicator,
      failureBuilder: (context) =>
          defaultFailureBuilder(context, text: failureMessage),
    );
  }

  const RemoteDataBuilder({
    required this.data,
    required this.isLoading,
    required this.builder,
    required this.loadingIndicator,
    required this.failureBuilder,
    super.key,
  });

  final bool isLoading;
  final T? data;
  final Widget Function(BuildContext context) loadingIndicator;
  final Widget Function(BuildContext context) failureBuilder;
  final Widget Function(BuildContext context, T data) builder;

  @override
  Widget build(BuildContext context) {
    return isNotBlank(data)
        ? builder(context, data as T)
        : isLoading
            ? loadingIndicator(context)
            : failureBuilder(context);
  }

  static Widget defaultLoadingIndicator(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  static Widget defaultFailureBuilder(BuildContext context, {String? text}) {
    return Center(
      child: Text(
        text ?? "No Data Found",
        style: AppStyles.of(context).sLarge.wBolder,
      ),
    );
  }

  static Widget sliverLoadingIndicator(BuildContext context) {
    return SliverToBoxAdapter(child: defaultLoadingIndicator(context));
  }

  static Widget sliverFailureBuilder(BuildContext context, {String? text}) {
    return SliverToBoxAdapter(
      child: defaultFailureBuilder(context, text: text),
    );
  }

  static Widget sliverCenterLoadingIndicator(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: defaultLoadingIndicator(context),
    );
  }

  static Widget sliverCenterFailureBuilder(
    BuildContext context, {
    String? text,
  }) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: defaultFailureBuilder(context, text: text),
    );
  }

  static Widget indicatorContainer({required Widget child}) {
    return Container(
      height: 56,
      width: 56,
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

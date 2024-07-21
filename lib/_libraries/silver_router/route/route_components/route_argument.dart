part of '../../silver_router_delegate.dart';

mixin RouteArgument {
  dynamic get argument;
  String get name;
  bool identifyName(String name) => name == this.name;

  SilverRoute copyWith({dynamic argument});

  String get urlInfo => encodeUrlInfo(name, encodeArgument(argument));

  bool identifyPath(
    BuildContext context,
    String urlInfo, [
    SilverRouteProxy? proxy,
  ]) =>
      (proxy ?? this).identifyName(urlInfo.split('=').first);

  FutureOr<SilverRoute> parse(
    BuildContext context,
    String urlInfo, [
    SilverRouteProxy? proxy,
  ]) async {
    final obj = proxy ?? this;
    final urlData = obj.decodeUrlInfo(urlInfo);
    final argument = await obj.decodeArgument(urlData.$2);
    return obj.copyWith(argument: argument);
  }

  String? encodeArgument(dynamic argument) => argument?.toString();
  FutureOr<dynamic>? decodeArgument(String? argument) => null;

  String encodeUrlInfo(String name, String? argument) {
    final hasArgument = argument != null && argument.isNotEmpty;
    return hasArgument ? '$name=$argument' : name;
  }

  (String, String?) decodeUrlInfo(String urlInfo) {
    final urlData = urlInfo.split('=');
    final name = urlData.first;
    String? argument = urlData.sublist(1).join('=');
    argument = argument.isEmpty ? null : argument;
    return (name, argument);
  }
}

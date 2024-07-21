import 'dart:ui';

import 'non_html_functions.dart' if (dart.library.html) 'html_functions.dart';

enum OperatingPlatform {
  linux,
  macos,
  windows,
  android,
  ios,
  fuchsia,
}

abstract class InternalWebFunctions {
  const InternalWebFunctions();

  void configureUrl();
  void urlLaunch(String url);
  String currentRoute();
  dynamic redirect(String url);
  void downloadFile(String imageUrl, String filename);

  Locale findSystemLocale() {
    final code = findSystemLanguageCode();
    return Locale(code.split('_').first, code.split('_').last);
  }

  String findSystemLanguageCode();

  OperatingPlatform get operatingSystem;
  String get operatingSystemVersion;
}

class WebFunctions extends HtmlFunctions {
  const WebFunctions._internal();
  static const _instance = WebFunctions._internal();
  factory WebFunctions() => _instance;
}

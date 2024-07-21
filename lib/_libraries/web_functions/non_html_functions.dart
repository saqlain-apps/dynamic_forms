import 'dart:io';

import 'package:intl/intl.dart';

import 'web_functions.dart';

class HtmlFunctions extends InternalWebFunctions {
  const HtmlFunctions();

  @override
  void configureUrl() {}

  @override
  void urlLaunch(String url) {}

  @override
  String currentRoute() => '';

  @override
  dynamic redirect(String url) {}

  @override
  void downloadFile(String imageUrl, String filename) async {}

  @override
  String findSystemLanguageCode() {
    return Intl.canonicalizedLocale(Platform.localeName);
  }

  @override
  OperatingPlatform get operatingSystem => OperatingPlatform.values
      .firstWhere((e) => e.name == Platform.operatingSystem);

  @override
  String get operatingSystemVersion => Platform.operatingSystemVersion;
}

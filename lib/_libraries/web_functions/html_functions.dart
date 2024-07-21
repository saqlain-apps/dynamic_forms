// ignore_for_file: unsafe_html, avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html';
import 'dart:js' as js;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;

import 'web_functions.dart';

class HtmlFunctions extends InternalWebFunctions {
  const HtmlFunctions();

  @override
  void configureUrl() {
    setUrlStrategy(PathUrlStrategy());
  }

  @override
  void urlLaunch(String url) {
    html.window.open(url, '_self');
  }

  @override
  String currentRoute() {
    return html.window.location.origin;
  }

  @override
  dynamic redirect(String url) {
    return js.context.callMethod('open', [url]);
  }

  @override
  void downloadFile(String imageUrl, String filename) async {
    final http.Response r = await http.get(
      Uri.parse(imageUrl),
    );

    // we get the bytes from the body
    final data = r.bodyBytes;
    // and encode them to base64
    final base64data = base64Encode(data);

    // then we create and AnchorElement with the html package
    final a = html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');

    // set the name of the file we want the image to get
    // downloaded to
    a.download = filename;

    // and we click the AnchorElement which downloads the image
    a.click();
    // finally we remove the AnchorElement
    a.remove();
  }

  @override
  String findSystemLanguageCode() {
    return Intl.canonicalizedLocale(window.navigator.language);
  }

  @override
  OperatingPlatform get operatingSystem {
    final s = html.window.navigator.userAgent.toLowerCase();
    if (s.contains('iphone') ||
        s.contains('ipad') ||
        s.contains('ipod') ||
        s.contains('watch os')) {
      return OperatingPlatform.ios;
    }
    if (s.contains('mac os')) {
      return OperatingPlatform.macos;
    }
    if (s.contains('fuchsia')) {
      return OperatingPlatform.fuchsia;
    }
    if (s.contains('android')) {
      return OperatingPlatform.android;
    }
    if (s.contains('linux') || s.contains('cros') || s.contains('chromebook')) {
      return OperatingPlatform.linux;
    }
    if (s.contains('windows')) {
      return OperatingPlatform.windows;
    }

    throw UnsupportedError('Web platform not found');
  }

  @override
  String get operatingSystemVersion {
    final userAgent = html.window.navigator.userAgent;

    // Android?
    {
      final regExp = RegExp('Android ([a-zA-Z0-9.-_]+)');
      final match = regExp.firstMatch(userAgent);
      if (match != null) {
        final version = match.group(1) ?? '';
        return version;
      }
    }

    // iPhone OS?
    {
      final regExp = RegExp('iPhone OS ([a-zA-Z0-9.-_]+) ([a-zA-Z0-9.-_]+)');
      final match = regExp.firstMatch(userAgent);
      if (match != null) {
        final version = (match.group(2) ?? '').replaceAll('_', '.');
        return version;
      }
    }

    // Mac OS X?
    {
      final regExp = RegExp('Mac OS X ([a-zA-Z0-9.-_]+)');
      final match = regExp.firstMatch(userAgent);
      if (match != null) {
        final version = (match.group(1) ?? '').replaceAll('_', '.');
        return version;
      }
    }

    // Chrome OS?
    {
      final regExp = RegExp('CrOS ([a-zA-Z0-9.-_]+) ([a-zA-Z0-9.-_]+)');
      final match = regExp.firstMatch(userAgent);
      if (match != null) {
        final version = match.group(2) ?? '';
        return version;
      }
    }

    // Windows NT?
    {
      final regExp = RegExp('Windows NT ([a-zA-Z0-9.-_]+)');
      final match = regExp.firstMatch(userAgent);
      if (match != null) {
        final version = (match.group(1) ?? '');
        return version;
      }
    }

    return '';
  }
}

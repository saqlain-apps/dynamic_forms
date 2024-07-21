enum AppConfigType {
  dev,
  testing,
  qa,
  stage,
  prod;

  bool get isDevelopment => this == dev;
  bool get isTesting => this == testing;
  bool get isQA => this == qa;
  bool get isRelease => this == stage || this == prod;

  AppConfig get config {
    return const DevConfig();
  }
}

abstract class AppConfig {
  const AppConfig._internal();

  factory AppConfig.custom(AppConfigType mode) {
    return mode.config;
  }

  factory AppConfig() => AppConfig.custom(globalModeType);

  AppConfigType get modeType;
  String get mode => modeType.name;

  String get baseUrl;

  static AppConfigType get globalModeType =>
      AppConfigType.values.firstWhere((e) => e.name == globalMode);
  static const String globalMode =
      String.fromEnvironment('mode', defaultValue: 'testing');
  static const bool debug = bool.fromEnvironment('debug');
}

class DevConfig extends AppConfig {
  const DevConfig() : super._internal();

  @override
  AppConfigType get modeType => AppConfigType.dev;

  @override
  String get baseUrl => const String.fromEnvironment('base_url');
}

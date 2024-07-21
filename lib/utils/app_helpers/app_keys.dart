import '/global/app_config.dart';

abstract class AppKeys {
  static AppConfig config = AppConfig();
  static String get baseUrl => config.baseUrl;
  static AppConfigType get mode => config.modeType;
  static bool get debug => AppConfig.debug;
}

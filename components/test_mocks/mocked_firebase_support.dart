import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/src/foundation/assertions.dart';
import 'package:onboarding_test/services/firebase_services/firebase_support.dart';

class MockedFirebaseSupport implements FirebaseSupport {
  @override
  final FirebaseAnalytics analytics = MockedFirebaseAnalytics();

  @override
  final FirebaseCrashlytics crashlytics = MockedFirebaseCrashlytics();

  @override
  final FirebaseApp firebaseApp = const MockedFirebaseApp();
}

class MockedFirebaseApp implements FirebaseApp {
  const MockedFirebaseApp();

  @override
  Future<void> delete() async {}

  @override
  bool get isAutomaticDataCollectionEnabled => false;

  @override
  String get name => "Mocked Firebase";

  @override
  FirebaseOptions get options => const FirebaseOptions(
      apiKey: "", appId: "", messagingSenderId: "", projectId: "");

  @override
  Future<void> setAutomaticDataCollectionEnabled(bool enabled) async {}

  @override
  Future<void> setAutomaticResourceManagementEnabled(bool enabled) async {}
}

class MockedFirebaseAnalytics implements FirebaseAnalytics {
  @override
  FirebaseApp app = const MockedFirebaseApp();

  @override
  FirebaseAnalyticsAndroid? get android => null;

  @override
  Future<String?> get appInstanceId async => null;

  @override
  Future<int?> getSessionId() async => null;

  @override
  Future<void> initiateOnDeviceConversionMeasurementWithEmailAddress(
      String emailAddress) async {}

  @override
  Future<void> initiateOnDeviceConversionMeasurementWithPhoneNumber(
      String phoneNumber) async {}

  @override
  Future<bool> isSupported() async => false;

  @override
  Future<void> logAdImpression(
      {String? adPlatform,
      String? adSource,
      String? adFormat,
      String? adUnitName,
      double? value,
      String? currency,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logAddPaymentInfo(
      {String? coupon,
      String? currency,
      String? paymentType,
      double? value,
      List<AnalyticsEventItem>? items,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logAddShippingInfo(
      {String? coupon,
      String? currency,
      double? value,
      String? shippingTier,
      List<AnalyticsEventItem>? items,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logAddToCart(
      {List<AnalyticsEventItem>? items,
      double? value,
      String? currency,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logAddToWishlist(
      {List<AnalyticsEventItem>? items,
      double? value,
      String? currency,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logAppOpen(
      {AnalyticsCallOptions? callOptions,
      Map<String, Object?>? parameters}) async {}

  @override
  Future<void> logBeginCheckout(
      {double? value,
      String? currency,
      List<AnalyticsEventItem>? items,
      String? coupon,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logCampaignDetails(
      {required String source,
      required String medium,
      required String campaign,
      String? term,
      String? content,
      String? aclid,
      String? cp1,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logEarnVirtualCurrency(
      {required String virtualCurrencyName,
      required num value,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logEcommercePurchase(
      {String? currency,
      double? value,
      String? transactionId,
      double? tax,
      double? shipping,
      String? coupon,
      String? location,
      int? numberOfNights,
      int? numberOfRooms,
      int? numberOfPassengers,
      String? origin,
      String? destination,
      String? startDate,
      String? endDate,
      String? travelClass}) async {}

  @override
  Future<void> logEvent(
      {required String name,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logGenerateLead(
      {String? currency,
      double? value,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logJoinGroup(
      {required String groupId,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logLevelEnd(
      {required String levelName,
      int? success,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logLevelStart(
      {required String levelName,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logLevelUp(
      {required int level,
      String? character,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logLogin(
      {String? loginMethod,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logPostScore(
      {required int score,
      int? level,
      String? character,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logPresentOffer(
      {required String itemId,
      required String itemName,
      required String itemCategory,
      required int quantity,
      double? price,
      double? value,
      String? currency,
      String? itemLocationId}) async {}

  @override
  Future<void> logPurchase(
      {String? currency,
      String? coupon,
      double? value,
      List<AnalyticsEventItem>? items,
      double? tax,
      double? shipping,
      String? transactionId,
      String? affiliation,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logPurchaseRefund(
      {String? currency, double? value, String? transactionId}) async {}

  @override
  Future<void> logRefund(
      {String? currency,
      String? coupon,
      double? value,
      double? tax,
      double? shipping,
      String? transactionId,
      String? affiliation,
      List<AnalyticsEventItem>? items,
      Map<String, Object?>? parameters}) async {}

  @override
  Future<void> logRemoveFromCart(
      {String? currency,
      double? value,
      List<AnalyticsEventItem>? items,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logScreenView(
      {String? screenClass,
      String? screenName,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logSearch(
      {required String searchTerm,
      int? numberOfNights,
      int? numberOfRooms,
      int? numberOfPassengers,
      String? origin,
      String? destination,
      String? startDate,
      String? endDate,
      String? travelClass,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logSelectContent(
      {required String contentType,
      required String itemId,
      Map<String, Object?>? parameters}) async {}

  @override
  Future<void> logSelectItem(
      {String? itemListId,
      String? itemListName,
      List<AnalyticsEventItem>? items,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logSelectPromotion(
      {String? creativeName,
      String? creativeSlot,
      List<AnalyticsEventItem>? items,
      String? locationId,
      String? promotionId,
      String? promotionName,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logSetCheckoutOption(
      {required int checkoutStep,
      required String checkoutOption,
      Map<String, Object?>? parameters}) async {}

  @override
  Future<void> logShare(
      {required String contentType,
      required String itemId,
      required String method,
      Map<String, Object?>? parameters}) async {}

  @override
  Future<void> logSignUp(
      {required String signUpMethod, Map<String, Object?>? parameters}) async {}

  @override
  Future<void> logSpendVirtualCurrency(
      {required String itemName,
      required String virtualCurrencyName,
      required num value,
      Map<String, Object?>? parameters}) async {}

  @override
  Future<void> logTutorialBegin({Map<String, Object?>? parameters}) async {}

  @override
  Future<void> logTutorialComplete({Map<String, Object?>? parameters}) async {}

  @override
  Future<void> logUnlockAchievement(
      {required String id, Map<String, Object?>? parameters}) async {}

  @override
  Future<void> logViewCart(
      {String? currency,
      double? value,
      List<AnalyticsEventItem>? items,
      Map<String, Object?>? parameters,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> logViewItem(
      {String? currency,
      double? value,
      List<AnalyticsEventItem>? items,
      Map<String, Object?>? parameters}) async {}

  @override
  Future<void> logViewItemList(
      {List<AnalyticsEventItem>? items,
      String? itemListId,
      String? itemListName,
      Map<String, Object?>? parameters}) async {}

  @override
  Future<void> logViewPromotion(
      {String? creativeName,
      String? creativeSlot,
      List<AnalyticsEventItem>? items,
      String? locationId,
      String? promotionId,
      String? promotionName,
      Map<String, Object?>? parameters}) async {}

  @override
  Future<void> logViewSearchResults(
      {required String searchTerm, Map<String, Object?>? parameters}) async {}

  @override
  Future<void> resetAnalyticsData() async {}

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {}

  @override
  Future<void> setConsent(
      {bool? adStorageConsentGranted,
      bool? analyticsStorageConsentGranted}) async {}

  @override
  Future<void> setCurrentScreen(
      {required String? screenName,
      String screenClassOverride = 'Flutter',
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> setDefaultEventParameters(
      Map<String, Object?>? defaultParameters) async {}

  @override
  Future<void> setSessionTimeoutDuration(Duration timeout) async {}

  @override
  Future<void> setUserId(
      {String? id, AnalyticsCallOptions? callOptions}) async {}

  @override
  Future<void> setUserProperty(
      {required String name,
      required String? value,
      AnalyticsCallOptions? callOptions}) async {}

  @override
  Map get pluginConstants => {};
}

class MockedFirebaseCrashlytics implements FirebaseCrashlytics {
  @override
  FirebaseApp app = const MockedFirebaseApp();

  @override
  Future<bool> checkForUnsentReports() async => false;

  @override
  void crash() {}

  @override
  Future<void> deleteUnsentReports() async {}

  @override
  Future<bool> didCrashOnPreviousExecution() async => false;

  @override
  bool get isCrashlyticsCollectionEnabled => false;

  @override
  Future<void> log(String message) async {}

  @override
  Map get pluginConstants => {};

  @override
  Future<void> recordError(exception, StackTrace? stack,
      {reason,
      Iterable<Object> information = const [],
      bool? printDetails,
      bool fatal = false}) async {}

  @override
  Future<void> recordFlutterError(FlutterErrorDetails flutterErrorDetails,
      {bool fatal = false}) async {}

  @override
  Future<void> recordFlutterFatalError(
      FlutterErrorDetails flutterErrorDetails) async {}

  @override
  Future<void> sendUnsentReports() async {}

  @override
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {}

  @override
  Future<void> setCustomKey(String key, Object value) async {}

  @override
  Future<void> setUserIdentifier(String identifier) async {}
}

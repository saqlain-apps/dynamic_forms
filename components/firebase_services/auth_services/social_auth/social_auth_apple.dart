import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'social_auth.dart';

mixin SocialAuthApple on SocialAuthBase {
  Future<AuthorizationCredentialAppleID?> signInWithApple() async {
    try {
      final credentials = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      return credentials;
    } on SignInWithAppleNotSupportedException {
      return null;
    } on SignInWithAppleAuthorizationException {
      return null;
    } catch (e) {
      rethrow;
    }
  }
}

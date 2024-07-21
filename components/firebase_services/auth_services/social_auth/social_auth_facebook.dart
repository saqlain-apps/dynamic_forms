import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'social_auth.dart';

mixin SocialAuthFacebook on SocialAuthBase {
  FacebookAuth get facebookAuth;

  Future<LoginResult?> signInWithFacebook() async {
    try {
      LoginResult facebookAccount = await facebookAuth.login();

      if (facebookAccount.status == LoginStatus.cancelled ||
          facebookAccount.status == LoginStatus.failed) {
        return null;
      }

      return facebookAccount;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> signOut() async {
    await facebookAuth.logOut();
    return await super.signOut();
  }
}

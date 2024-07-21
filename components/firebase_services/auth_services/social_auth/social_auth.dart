import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'social_auth_apple.dart';
import 'social_auth_facebook.dart';
import 'social_auth_google.dart';

class SocialAuth extends SocialAuthBase
    with SocialAuthGoogle, SocialAuthFacebook, SocialAuthApple {
  SocialAuth({
    GoogleSignIn? googleSignIn,
    FacebookAuth? facebookSignIn,
  })  : _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _facebookAuth = facebookSignIn ?? FacebookAuth.instance;

  @override
  final GoogleSignIn _googleSignIn;

  @override
  final FacebookAuth _facebookAuth;
}

abstract class SocialAuthBase {
  const SocialAuthBase();

  Future<bool> signOut() async {
    print('Signed Out');
    return true;
  }
}

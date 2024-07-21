import 'package:google_sign_in/google_sign_in.dart';

import 'social_auth.dart';

mixin SocialAuthGoogle on SocialAuthBase {
  GoogleSignIn get googleSignIn;

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      return await googleSignIn.signIn();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> signOut() async {
    await googleSignIn.signOut();
    return await super.signOut();
  }
}

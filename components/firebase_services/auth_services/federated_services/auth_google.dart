part of '../auth_services.dart';

mixin AuthGoogle on AuthServiceBase {
  SocialAuthGoogle get _googleSignIn;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleAccount =
          await _googleSignIn.signInWithGoogle();
      if (googleAccount == null) return null;

      var googleCredentials = await googleAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleCredentials.idToken,
        accessToken: googleCredentials.accessToken,
      );

      var userCredentials = await service.signInWithCredential(credential);
      return userCredentials;
    } on FirebaseAuthException catch (e) {
      return await handleExceptions<UserCredential?>(e, null);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> signOut() async {
    await _googleSignIn.signOut();
    return await super.signOut();
  }
}

part of '../auth_services.dart';

mixin AuthFacebook on AuthServiceBase {
  SocialAuthFacebook get _facebookAuth;

  Future<UserCredential?> signInWithFacebook() async {
    try {
      LoginResult? facebookAccount = await _facebookAuth.signInWithFacebook();
      if (facebookAccount == null) return null;

      AuthCredential credential = FacebookAuthProvider.credential(
        facebookAccount.accessToken!.token,
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
    await _facebookAuth.signOut();
    return await super.signOut();
  }
}

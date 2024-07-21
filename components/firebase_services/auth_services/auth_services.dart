import 'dart:async';

import 'social_auth/social_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_touch/utils/app_helpers/_app_helper_import.dart';

part 'auth_exception.dart';
part 'federated_services/auth_facebook.dart';
part 'federated_services/auth_google.dart';
part 'generic_methods/auth_anonymous.dart';
part 'generic_methods/auth_password.dart';
part 'generic_methods/auth_phone.dart';

class AuthServices extends AuthServiceBase
    with AuthAnonymous, AuthPassword, AuthGoogle, AuthFacebook {
  AuthServices({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
    FacebookAuth? facebookSignIn,
  })  : service = auth ?? FirebaseAuth.instance,
        _socialAuth = SocialAuth(
          googleSignIn: googleSignIn,
          facebookSignIn: facebookSignIn,
        );

  @override
  SocialAuthFacebook get _facebookAuth => _socialAuth;

  @override
  SocialAuthGoogle get _googleSignIn => _socialAuth;

  final SocialAuth _socialAuth;

  @override
  final FirebaseAuth service;
}

abstract class AuthServiceBase {
  const AuthServiceBase();

  FirebaseAuth get service;

  Stream<User?> get userState => service.userChanges();
  String? get userEmail => currentUser?.email;
  String? get currentUserId => currentUser?.uid;
  User? get currentUser => service.currentUser;
  bool get isSignedIn => currentUser != null;

  Future<List<String>> getSignInMethodsForEmail(String email) async {
    return await service.fetchSignInMethodsForEmail(email);
  }

  Future<bool> isUserVerified() async {
    if (currentUser == null) return false;

    try {
      await currentUser!.reload();
    } catch (e) {
      printError(e);
      rethrow;
    }

    return currentUser!.emailVerified;
  }

  Future<UserCredential?> linkWithProvider(AuthProvider provider) async {
    if (currentUser == null) return null;

    try {
      var userCredentials = kIsWeb
          ? await currentUser!.linkWithPopup(provider)
          : await currentUser!.linkWithProvider(provider);
      return userCredentials;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> linkWithCredentials(
      AuthCredential credentials) async {
    if (currentUser == null) return null;

    try {
      var userCredentials = await currentUser!.linkWithCredential(credentials);
      return userCredentials;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateProfile({String? name, String? profilePicture}) async {
    if (!isSignedIn) return false;
    if (name == null && profilePicture == null) return true;

    try {
      if (name != null) await currentUser!.updateDisplayName(name);
      if (profilePicture != null) {
        await currentUser!.updatePhotoURL(profilePicture);
      }
      return true;
    } on FirebaseAuthException catch (e) {
      return handleExceptions<bool>(e, false);
    } catch (e) {
      rethrow;
    }
  }

  Future<T> handleExceptions<T>(
    FirebaseAuthException error,
    T defaultValue,
  ) async {
    switch (error.code) {
      // Network error (such as timeout, interrupted connection or
      // unreachable host) has occurred.
      case 'network-request-failed':
        throw AuthException.withFirebaseException(
          error,
          message: AppStrings.current.authNetworkConnectionFailed,
        );

      // Thrown if there already exists an account with the given email address.
      case 'internal-error':
        throw AuthException.withFirebaseException(error,
            message: AppStrings.current.errorUnknown);

      // Thrown if there already exists an account with the given email address.
      case 'email-already-in-use':
        throw AuthException.withFirebaseException(error);

      // Thrown if the email address is not valid.
      case 'invalid-email':
        throw AuthException.withFirebaseException(error);

      // Thrown if the password is not strong enough.
      case 'weak-password':
        throw AuthException.withFirebaseException(error);

      // Thrown if the user corresponding to the given email has been disabled.
      case 'user-disabled':
        throw AuthException.withFirebaseException(error);

      // Thrown if there is no user corresponding to the given email.
      case 'user-not-found':
        throw AuthException.withFirebaseException(error,
            message: AppStrings.current.authUserNotFound);

      // Thrown if the password is invalid for the given email,
      // or the account corresponding to the email does not have a password set.
      case 'wrong-password':
        throw AuthException.withFirebaseException(error);

      // // Thrown if the email address is not valid.
      // case 'auth/invalid-email':
      //   throw AuthException.withFirebaseException(error);

      // // Thrown if there is no user corresponding to the email address.
      // case 'auth/user-not-found':
      //   throw AuthException.withFirebaseException(error);

      // Thrown if the provider has already been linked to the user.
      // This error is thrown even if this is not the same provider's account
      // that is currently linked to the user.
      case 'provider-already-linked':
        throw AuthException.withFirebaseException(error);

      // Thrown if the provider's credential is not valid.
      // This can happen if it has already expired when calling link,
      // or if it used invalid token(s).
      case 'invalid-credential':
        throw AuthException.withFirebaseException(error);

      // Thrown if the account corresponding to the credential already exists
      // among your users, or is already linked to a Firebase User.
      // For example, this error could be thrown if you are upgrading an
      // anonymous user to a Google user by linking a Google credential to it
      // and the Google credential used is already associated with an existing
      // Firebase Google user.
      // The fields email, phoneNumber, and credential ([AuthCredential]) may
      // be provided, depending on the type of credential.
      // You can recover from this error by signing in with credential directly
      // via [signInWithCredential].
      // Please note, you will not recover from this error if you're using
      // a [PhoneAuthCredential] to link a provider to an account.
      // Once an attempt to link an account has been made,
      // a new sms code is required to sign in the user.
      case 'credential-already-in-use':
        throw AuthException.withFirebaseException(error);

      // Thrown if the credential is a [PhoneAuthProvider.credential] and the
      // verification code of the credential is not valid.
      case 'invalid-verification-code':
        throw AuthException.withFirebaseException(error);

      // Thrown if the credential is a [PhoneAuthProvider.credential] and the
      // verification ID of the credential is not valid.
      case 'invalid-verification-id':
        throw AuthException.withFirebaseException(error);

      // Thrown if the user's last sign-in time does not meet the
      // security threshold. Use [User.reauthenticateWithCredential] to resolve.
      // This does not apply if the user is anonymous.
      case 'requires-recent-login':
        throw AuthException.withFirebaseException(error);

      // Thrown if the action code has expired.
      case 'expired-action-code':
        throw AuthException.withFirebaseException(error);

      // Thrown if the action code is invalid. This can happen if the code is
      // malformed or has already been used.
      case 'invalid-action-code':
        throw AuthException.withFirebaseException(error);

      default:
        throw error;
    }
    // return defaultValue;
  }

  Future<bool> signOut() async {
    printPersistent('Signed Out');
    if (!isSignedIn) return false;

    await service.signOut();
    return !isSignedIn;
  }

  Future<bool> deleteUser() async {
    printPersistent('Delete Account');
    if (!isSignedIn) return false;

    try {
      await currentUser!.delete();
      return !isSignedIn;
    } on FirebaseAuthException catch (e) {
      return await handleExceptions<bool>(e, false);
    } catch (e) {
      rethrow;
    }
  }
}

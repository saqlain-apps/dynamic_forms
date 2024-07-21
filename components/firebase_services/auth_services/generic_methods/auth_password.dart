// ignore_for_file: unused_local_variable

part of '../auth_services.dart';

mixin AuthPassword on AuthServiceBase {
  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      var userCredentials = await service.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await service.currentUser!.sendEmailVerification();
      return userCredentials;
    } on FirebaseAuthException catch (e) {
      return await handleExceptions<UserCredential?>(e, null);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      var userCredentials = await service.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredentials;
    } on FirebaseAuthException catch (e) {
      return await handleExceptions<UserCredential?>(e, null);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> sendVerificationMail() async {
    if (!isSignedIn) return false;

    try {
      var isAlreadyVerified = await isUserVerified();
      if (isAlreadyVerified) return false;

      await currentUser!.sendEmailVerification();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updatePassword(String password) async {
    if (!isSignedIn) return false;

    try {
      await currentUser!.updatePassword(password);
      return true;
    } on FirebaseAuthException catch (e) {
      return handleExceptions<bool>(e, false);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateEmail(String email) async {
    if (!isSignedIn) return false;

    try {
      await currentUser!.updateEmail(email);
      return true;
    } on FirebaseAuthException catch (e) {
      return handleExceptions<bool>(e, false);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> applyActionCode(String code) async {
    try {
      await service.applyActionCode(code);
      return true;
    } on FirebaseAuthException catch (e) {
      return handleExceptions<bool>(e, false);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> sendPasswordResetCode(String email) async {
    try {
      await service.sendPasswordResetEmail(
        email: email,
        // actionCodeSettings: ActionCodeSettings(url: url),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      return handleExceptions<bool>(e, false);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> confirmPasswordReset(String code, String password) async {
    try {
      await service.confirmPasswordReset(code: code, newPassword: password);
      return true;
    } on FirebaseAuthException catch (e) {
      return handleExceptions<bool>(e, false);
    } catch (e) {
      rethrow;
    }
  }
}

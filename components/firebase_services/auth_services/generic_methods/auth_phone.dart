// ignore_for_file: unused_local_variable

part of '../auth_services.dart';

mixin AuthPhone on AuthServiceBase {
  Future<UserCredential?> phoneAuthentication({required String phone}) async {
    return kIsWeb
        ? _webPhoneAuthentication(phone: phone)
        : _mobilePhoneAuthentication(phone: phone);
  }

  // TODO: Incomplete
  Future<UserCredential?> _mobilePhoneAuthentication(
      {required String phone}) async {
    assert(!kIsWeb);
    try {
      UserCredential? userCredentials;
      await service.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (phoneAuthCredential) async {
          // Android Only
          userCredentials =
              await service.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (error) async {
          userCredentials =
              await handleExceptions<UserCredential?>(error, null);
        },
        codeSent: (verificationId, forceResendingToken) async {
          // Update the UI - wait for the user to enter the SMS code
          String smsCode = 'xxxx';

          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);

          userCredentials = await service.signInWithCredential(credential);
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );

      return userCredentials;
    } on FirebaseAuthException catch (e) {
      return await handleExceptions<UserCredential?>(e, null);
    } catch (e) {
      rethrow;
    }
  }

  // TODO: Incomplete
  Future<UserCredential?> _webPhoneAuthentication(
      {required String phone}) async {
    assert(kIsWeb);
    try {
      var confirmationResult = await service.signInWithPhoneNumber(phone);
      var userCredentials = await confirmationResult.confirm('xxxx');

      return userCredentials;
    } on FirebaseAuthException catch (e) {
      return await handleExceptions<UserCredential?>(e, null);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> _updatePhone(PhoneAuthCredential phoneAuthCredentials) async {
    if (!isSignedIn) return false;

    try {
      await currentUser!.updatePhoneNumber(phoneAuthCredentials);
      return true;
    } on FirebaseAuthException catch (e) {
      return handleExceptions<bool>(e, false);
    } catch (e) {
      rethrow;
    }
  }
}

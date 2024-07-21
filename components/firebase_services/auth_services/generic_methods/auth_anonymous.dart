// ignore_for_file: unused_local_variable

part of '../auth_services.dart';

mixin AuthAnonymous on AuthServiceBase {
  Future<UserCredential?> signInAnonymously() async {
    try {
      var userCredentials = await service.signInAnonymously();
      return userCredentials;
    } on FirebaseAuthException catch (e) {
      return await handleExceptions<UserCredential?>(e, null);
    } catch (e) {
      rethrow;
    }
  }
}

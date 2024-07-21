part of 'auth_services.dart';

enum AuthExceptionCode {
  none,
  internalError,
  networkRequestFailed,
  emailAlreadyInUse,
  invalidEmail,
  weakPassword,
  userDisabled,
  wrongPassword,
  authInvalidEmail,
  authUserNotFound,
  providerAlreadyLinked,
  invalidCredential,
  credentialAlreadyInUse,
  invalidVerificationCode,
  invalidVerificationId,
  requiresRecentLogin,
  expiredActionCode,
  invalidActionCode,
  userNotFound;

  static AuthExceptionCode fromFirebaseException(FirebaseAuthException error) {
    var code = error.code.replaceAll('-', '').replaceAll('/', '');

    return AuthExceptionCode.values.findWhere(
          (element) => element.name.toLowerCase() == code.toLowerCase(),
        ) ??
        AuthExceptionCode.none;
  }
}

class AuthException {
  factory AuthException.withFirebaseException(FirebaseAuthException error,
      {String? message}) {
    return AuthException(
      code: AuthExceptionCode.fromFirebaseException(error),
      message: message,
      firebaseCode: error.code,
      firebaseMessage: error.message,
    );
  }

  const AuthException({
    required this.code,
    this.message,
    this.firebaseCode,
    this.firebaseMessage,
  });

  final AuthExceptionCode code;
  final String? message;
  final String? firebaseCode;
  final String? firebaseMessage;

  String get firebaseException => ''
      '${firebaseCode ?? ''}:\n'
      '${firebaseMessage ?? ''}';

  String get exception => ''
      '${code.name}:\n'
      '${message ?? ''}';

  @override
  String toString() => firebaseException;
}

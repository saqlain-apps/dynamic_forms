class AppException implements Exception {
  const AppException({
    required this.errorCode,
    required this.message,
    required this.exception,
  });

  final int errorCode;
  final String message;
  final String exception;
}

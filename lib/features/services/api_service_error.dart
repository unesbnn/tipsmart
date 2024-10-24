import 'package:dio/dio.dart';

import '../../commons/strings.dart';

class ApiServiceError implements Exception {
  final String message;

  const ApiServiceError([this.message = Strings.somethingWentWrong]);

  factory ApiServiceError.fromType(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.cancel:
        return const ApiServiceError(Strings.apiDefaultErrorMsg);
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.badResponse:
        return const ApiServiceError(Strings.apiReceiveTimeout);
      default:
        return const ApiServiceError();
    }
  }
}

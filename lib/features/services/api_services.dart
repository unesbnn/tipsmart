import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../keys/keys.dart';
import 'api_service_error.dart';

class ApiServices {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://tipadvisor-betting-tips.p.rapidapi.com',
      headers: {
        'X-RapidAPI-Host': 'tipadvisor-betting-tips.p.rapidapi.com',
        'X-RapidAPI-Key': Keys.apiFootballApiKey,
      },
      // connectTimeout: const Duration(seconds: 10),
      // receiveTimeout: const Duration(seconds: 15),
      // sendTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(DebugInterceptors());

  static Future getApiResponse({required String path}) async {
    Response response;
    try {
      response = await _dio.get(path);

      if(response.statusCode != 200) {
        throw const ApiServiceError();
      } else if(!response.data['success']) {
        throw ApiServiceError(response.data['error']);
      }

      return response;
    } on DioException catch (e) {
      throw ApiServiceError.fromType(e.type);
    } on Exception catch (_) {
      throw const ApiServiceError();
    }
  }
}

class DebugInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    return super.onError(err, handler);
  }
}

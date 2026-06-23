import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../errors/app_exception.dart';
import '../storage/hive_constants.dart';
import '../storage/hive_storage.dart';
import 'api_endpoints.dart';

@singleton
class DioClient {
  late final Dio _dio;

  DioClient(HiveStorage hiveStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(hiveStorage),
      if (kDebugMode) _LogInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  final HiveStorage _hiveStorage;

  _AuthInterceptor(this._hiveStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _hiveStorage.read<String>(HiveBoxes.auth, HiveKeys.token);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('[DioClient] → ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('[DioClient] ← ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('[DioClient] ✗ ${err.type} ${err.requestOptions.uri}: ${err.message}');
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppException appException;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        appException = const NetworkException(
          'Request timed out. Please check your connection and try again.',
        );
        break;
      case DioExceptionType.connectionError:
        appException = const NetworkException(
          'No internet connection. Please check your network.',
        );
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode ?? 0;
        if (statusCode == 401) {
          appException = const UnauthorizedException('Unauthorized. Please login again.');
        } else if (statusCode >= 500) {
          appException = ServerException('Server error ($statusCode). Please try later.');
        } else {
          appException = ServerException('Request failed ($statusCode).');
        }
        break;
      default:
        appException = ServerException(err.message ?? 'An unexpected error occurred.');
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: appException,
        message: appException.message,
      ),
    );
  }
}

// Extension to extract AppException from DioException
extension DioExceptionExt on DioException {
  AppException get appException {
    if (error is AppException) return error as AppException;
    return ServerException(message ?? 'Unknown error');
  }
}

import 'package:dio/dio.dart';
import 'env.dart';
import 'storage.dart';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: Env.backend,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  ),
)..interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await AppStorage.readJwt();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
  ),
);

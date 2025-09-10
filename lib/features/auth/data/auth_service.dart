import 'package:dio/dio.dart';
import '../../../core/api.dart';
import '../../../core/storage.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await dio.post('/auth/login', data: {'email': email, 'password': password});
    final data = res.data as Map<String, dynamic>;
    await AppStorage.saveTokens(data['accessToken'], data['refreshToken']);
    return data;
  }

  Future<void> activate(String token, String password) async {
    final res = await dio.post('/auth/activate', data: {'token': token, 'password': password});
    final data = res.data as Map<String, dynamic>;
    await AppStorage.saveTokens(data['accessToken'], data['refreshToken']);
  }

  Future<String?> refresh() async {
    final rt = await AppStorage.readRefresh();
    if (rt == null) return null;
    try {
      final res = await dio.post('/auth/refresh', data: {'refreshToken': rt});
      final at = (res.data as Map<String, dynamic>)['accessToken'] as String;
      await AppStorage.saveTokens(at, rt);
      return at;
    } on DioException {
      await AppStorage.clear();
      rethrow;
    }
  }

  Future<void> logout() async {
    await AppStorage.clear();
  }

  Future<String?> currentToken() => AppStorage.readJwt();
}

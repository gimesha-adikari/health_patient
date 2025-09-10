import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppStorage {
  static const _storage = FlutterSecureStorage();
  static const _jwtKey = 'jwt';
  static const _refreshKey = 'refresh';

  static Future<void> saveTokens(String access, String refresh) async {
    await _storage.write(key: _jwtKey, value: access);
    await _storage.write(key: _refreshKey, value: refresh);
  }

  static Future<String?> readJwt() => _storage.read(key: _jwtKey);
  static Future<String?> readRefresh() => _storage.read(key: _refreshKey);

  static Future<void> clear() async {
    await _storage.delete(key: _jwtKey);
    await _storage.delete(key: _refreshKey);
  }
}

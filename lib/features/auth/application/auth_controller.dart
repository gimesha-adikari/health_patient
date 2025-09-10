import '../../auth/data/auth_service.dart';

class AuthController {
  final AuthService _svc;
  AuthController([AuthService? svc]) : _svc = svc ?? AuthService();

  Future<void> login(String email, String password) => _svc.login(email, password);
  Future<void> logout() => _svc.logout();
}

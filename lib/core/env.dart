class Env {
  static const backend =
  String.fromEnvironment('BACKEND_URL', defaultValue: 'http://10.0.2.2:4000');
}
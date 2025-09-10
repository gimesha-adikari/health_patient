import 'package:flutter/material.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/activate_page.dart';
import '../features/scoring/presentation/score_page.dart';
import '../features/scoring/presentation/result_page.dart';

Route<dynamic>? appOnGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const LoginPage());
    case '/activate':
      return MaterialPageRoute(builder: (_) => const ActivatePage());
    case '/score':
      return MaterialPageRoute(builder: (_) => const ScorePage());
    case '/score/result':
      final data = (settings.arguments as Map<String, dynamic>?) ?? const {};
      return MaterialPageRoute(builder: (_) => ResultPage(result: data));
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(body: Center(child: Text('Not found'))),
      );
  }
}

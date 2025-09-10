import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../auth/data/auth_service.dart';

class ActivatePage extends StatefulWidget {
  const ActivatePage({super.key});
  @override
  State<ActivatePage> createState() => _ActivatePageState();
}

class _ActivatePageState extends State<ActivatePage> {
  final _formKey = GlobalKey<FormState>();
  final _token = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String? _msg;
  final _auth = AuthService();

  @override
  void dispose() {
    _token.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _onActivate() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _msg = null;
    });
    try {
      await _auth.activate(_token.text.trim(), _pass.text);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/score');
    } on DioException catch (e) {
      setState(() => _msg = e.response?.data?['error'] ?? 'Activation failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget gradientBg({required Widget child}) => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primary.withOpacity(0.10),
            cs.tertiaryContainer.withOpacity(0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );

    return Scaffold(
      body: gradientBg(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Activate account', style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 6),
                          Text(
                            'Paste the invite token sent by your hospital and set a new password.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          if (_msg != null)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: cs.errorContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(_msg!, style: TextStyle(color: cs.onErrorContainer)),
                            ),
                          TextFormField(
                            controller: _token,
                            decoration: const InputDecoration(
                              labelText: 'Invite token',
                              prefixIcon: Icon(Icons.qr_code_2_outlined),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Token is required' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _pass,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              labelText: 'New password',
                              prefixIcon: const Icon(Icons.lock_reset_outlined),
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => _obscure = !_obscure),
                                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                              ),
                            ),
                            validator: (v) => (v == null || v.length < 6) ? 'Minimum 6 characters' : null,
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _loading ? null : _onActivate,
                            child: Text(_loading ? 'Activating…' : 'Activate'),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _loading ? null : () => Navigator.of(context).pop(),
                            child: const Text('Back to sign in'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

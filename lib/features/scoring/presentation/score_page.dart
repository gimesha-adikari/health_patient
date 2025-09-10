import 'dart:async';
import 'package:flutter/material.dart';
import '../../scoring/data/score_service.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});
  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  final _svc = ScoreService();
  String? _jobId;
  Map<String, dynamic>? _result;
  Timer? _poll;

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _enqueue() async {
    final id = await _svc.enqueue('demo');
    setState(() {
      _jobId = id;
      _result = null;
    });
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(seconds: 1), (_) => _check());
  }

  Future<void> _check() async {
    if (_jobId == null) return;
    final info = await _svc.status(_jobId!);
    final state = info['state'] as String?;
    if (state == 'completed') {
      _poll?.cancel();
      final res = info['returnvalue'] as Map<String, dynamic>?;
      if (!mounted) return;
      Navigator.pushNamed(context, '/score/result', arguments: res ?? const {});
    }
    if (state == 'failed') {
      _poll?.cancel();
      setState(() => _result = {'error': info['failedReason']});
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Risk Score')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cs.primary.withOpacity(0.06), cs.surfaceVariant.withOpacity(0.06)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.favorite_rounded, color: cs.primary, size: 40),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('On-demand risk scoring', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 6),
                            Text(
                              'Trigger a demo scoring job and view the live result.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: FilledButton.icon(
                                onPressed: _enqueue,
                                icon: const Icon(Icons.play_arrow_rounded),
                                label: const Text('Enqueue demo job'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_jobId != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const CircularProgressIndicator(strokeWidth: 3),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('Processing job: $_jobId', maxLines: 2, overflow: TextOverflow.ellipsis),
                        ),
                        IconButton(
                          tooltip: 'Refresh now',
                          onPressed: _check,
                          icon: const Icon(Icons.refresh_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_result != null) ...[
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Result: $_result',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

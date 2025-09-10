import 'dart:math' as math;
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final Map<String, dynamic> result;
  const ResultPage({super.key, required this.result});

  Color _bandColor(ColorScheme cs, String band) {
    switch (band.toLowerCase()) {
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.amber;
      case 'red':
        return cs.error;
      default:
        return cs.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final band = (result['band'] ?? '-').toString();
    final score = (result['score'] is num) ? (result['score'] as num).toDouble() : double.tryParse('${result['score']}') ?? 0.0;
    final reasons = (result['reasons'] as List?)?.map((e) => '$e').toList() ?? const <String>[];
    final model = (result['model_version'] ?? '-').toString();
    final bandCol = _bandColor(cs, band);

    return Scaffold(
      appBar: AppBar(title: const Text('Score Result')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    _ScoreDial(value: score.clamp(0.0, 1.0), color: bandCol),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Chip(
                                label: Text('Band: $band'),
                                backgroundColor: bandCol.withOpacity(0.15),
                                side: BorderSide(color: bandCol.withOpacity(0.4)),
                              ),
                              Chip(
                                label: Text('Score: ${score.toStringAsFixed(2)}'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'The score is a probability-like value (0–1). Higher means higher risk.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Top factors', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (reasons.isEmpty)
                      Text('—', style: Theme.of(context).textTheme.bodyMedium)
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: reasons
                            .take(8)
                            .map((r) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.brightness_1, size: 8),
                              const SizedBox(width: 8),
                              Expanded(child: Text('$r')),
                            ],
                          ),
                        ))
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.model_training_outlined),
                title: const Text('Model version'),
                subtitle: Text(model),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreDial extends StatelessWidget {
  final double value; // 0..1
  final Color color;
  const _ScoreDial({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: 120,
      height: 120,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, v, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: v,
                strokeWidth: 10,
                color: color,
                backgroundColor: cs.surfaceVariant.withOpacity(0.4),
              ),
              Text('${(v * 100).round()}%', style: Theme.of(context).textTheme.titleLarge),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../data/content_repository.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  late final Future<StorageGuide> _guideFuture;
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    _guideFuture = ContentRepository().loadTomatoStorage();
  }

  static Color _stageColor(String key) {
    switch (key) {
      case 'green':
        return Colors.green;
      case 'turning':
        return Colors.orange;
      case 'red':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static IconData _stepIcon(String key) {
    switch (key) {
      case 'check':
        return Icons.search;
      case 'sun':
        return Icons.wb_sunny_outlined;
      case 'air':
        return Icons.air;
      case 'stack':
        return Icons.layers;
      case 'water':
        return Icons.water_drop_outlined;
      case 'sell':
        return Icons.sell;
      case 'cool':
        return Icons.thermostat;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store my tomatoes')),
      body: SafeArea(
        child: FutureBuilder<StorageGuide>(
          future: _guideFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Could not load the guide.\n${snapshot.error}'),
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final guide = snapshot.data!;
            final stage = guide.stages[_selected];
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (!guide.verified) const _DraftBanner(),
                const SizedBox(height: 12),
                const Text(
                  'How ripe are your tomatoes?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    for (var i = 0; i < guide.stages.length; i++) ...[
                      Expanded(
                        child: _StageChoice(
                          label: guide.stages[i].label,
                          color: _stageColor(guide.stages[i].color),
                          selected: i == _selected,
                          onTap: () => setState(() => _selected = i),
                        ),
                      ),
                      if (i < guide.stages.length - 1)
                        const SizedBox(width: 10),
                    ],
                  ],
                ),
                const SizedBox(height: 20),
                for (final step in stage.steps) ...[
                  _StepCard(icon: _stepIcon(step.icon), text: step.text),
                  const SizedBox(height: 10),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DraftBanner extends StatelessWidget {
  const _DraftBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded),
          SizedBox(width: 10),
          Expanded(
            child: Text('Draft content. Not yet checked by an expert.'),
          ),
        ],
      ),
    );
  }
}

class _StageChoice extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _StageChoice({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: selected ? 3 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 20, backgroundColor: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const _StepCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: scheme.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 18, height: 1.3)),
          ),
        ],
      ),
    );
  }
}

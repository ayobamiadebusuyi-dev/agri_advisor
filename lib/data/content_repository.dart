import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// One instruction shown to the farmer, with an icon key and short text.
class StorageStep {
  final String icon;
  final String text;

  const StorageStep({required this.icon, required this.text});

  factory StorageStep.fromJson(Map<String, dynamic> json) {
    return StorageStep(
      icon: json['icon'] as String,
      text: json['text'] as String,
    );
  }
}

/// A ripeness stage (green, turning, red) and its storage steps.
class RipenessStage {
  final String id;
  final String label;
  final String color;
  final List<StorageStep> steps;

  const RipenessStage({
    required this.id,
    required this.label,
    required this.color,
    required this.steps,
  });

  factory RipenessStage.fromJson(Map<String, dynamic> json) {
    final rawSteps = json['steps'] as List<dynamic>;
    return RipenessStage(
      id: json['id'] as String,
      label: json['label'] as String,
      color: json['color'] as String,
      steps: rawSteps
          .map((s) => StorageStep.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// The whole storage guide for one crop.
class StorageGuide {
  final String crop;
  final bool verified;
  final List<RipenessStage> stages;

  const StorageGuide({
    required this.crop,
    required this.verified,
    required this.stages,
  });

  factory StorageGuide.fromJson(Map<String, dynamic> json) {
    final rawStages = json['stages'] as List<dynamic>;
    return StorageGuide(
      crop: json['crop'] as String,
      verified: json['verified'] as bool,
      stages: rawStages
          .map((s) => RipenessStage.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Loads content that ships inside the app, so it works with no internet.
class ContentRepository {
  Future<StorageGuide> loadTomatoStorage() async {
    final raw = await rootBundle.loadString('assets/data/storage_tomato.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return StorageGuide.fromJson(json);
  }
}

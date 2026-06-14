// ============================================================
// [Software Eng] Prediction & Model Data Models
// ============================================================

class PredictionRequest {
  final String text;
  final String? imagePath;
  final Map<String, dynamic> userData;
  final Map<String, dynamic>? propagationData;

  PredictionRequest({
    required this.text,
    this.imagePath,
    this.userData = const {},
    this.propagationData,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'image_path': imagePath,
    'user_data': userData,
    'propagation_data': propagationData,
  };
}

class PredictionResponse {
  final bool isMisinformation;
  final double confidence;
  final double suspicionScore;
  final Map<String, dynamic> modalityBreakdown;
  final Map<String, dynamic> explanation;

  PredictionResponse({
    required this.isMisinformation,
    required this.confidence,
    required this.suspicionScore,
    required this.modalityBreakdown,
    required this.explanation,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      isMisinformation: json['is_misinformation'] as bool,
      confidence: (json['confidence'] as num).toDouble(),
      suspicionScore: (json['suspicion_score'] as num).toDouble(),
      modalityBreakdown: json['modality_breakdown'] as Map<String, dynamic>,
      explanation: json['explanation'] as Map<String, dynamic>,
    );
  }
}

class HealthResponse {
  final String status;
  final bool modelLoaded;
  final String version;

  HealthResponse({
    required this.status,
    required this.modelLoaded,
    required this.version,
  });

  factory HealthResponse.fromJson(Map<String, dynamic> json) {
    return HealthResponse(
      status: json['status'] as String,
      modelLoaded: json['model_loaded'] as bool,
      version: json['version'] as String,
    );
  }
}

class ModelInfo {
  final Map<String, double> modalityImportance;
  final int textEncoderParams;
  final int imageEncoderParams;
  final int fusionParams;
  final bool textEncoderFrozen;
  final String device;

  ModelInfo({
    required this.modalityImportance,
    required this.textEncoderParams,
    required this.imageEncoderParams,
    required this.fusionParams,
    required this.textEncoderFrozen,
    required this.device,
  });

  factory ModelInfo.fromJson(Map<String, dynamic> json) {
    return ModelInfo(
      modalityImportance:
          (json['modality_importance'] as Map<String, dynamic>)
              .map((k, v) => MapEntry(k, (v as num).toDouble())),
      textEncoderParams: json['text_encoder_params'] as int,
      imageEncoderParams: json['image_encoder_params'] as int,
      fusionParams: json['fusion_params'] as int,
      textEncoderFrozen: json['text_encoder_frozen'] as bool,
      device: json['device'] as String,
    );
  }
}

class PostItem {
  final String id;
  final String title;
  final String snippet;
  final double suspicionScore;
  final String source;
  final DateTime timestamp;
  final bool hasImage;
  final List<String> modalityIcons;

  PostItem({
    required this.id,
    required this.title,
    required this.snippet,
    required this.suspicionScore,
    required this.source,
    required this.timestamp,
    this.hasImage = false,
    this.modalityIcons = const [],
  });
}

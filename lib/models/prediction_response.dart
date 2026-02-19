import 'prediction.dart';
import 'xai_explanation.dart';

class PredictionResponse {
  final bool success;
  final String predictedClass;
  final double confidence;
  final String confidencePercentage;
  final bool isFish;
  final bool isUncertain;
  final String message;
  final List<Prediction> allPredictions;
  final String? gradcamHeatmapOverlay; // base64 PNG with red bounding box
  final String? gradcamHeatmapOnly; // base64 PNG
  final double? affectedAreaPercentage; // e.g. 21.1 means 21.1%
  final XaiExplanation? xai;

  PredictionResponse({
    required this.success,
    required this.predictedClass,
    required this.confidence,
    required this.confidencePercentage,
    required this.isFish,
    required this.isUncertain,
    required this.message,
    required this.allPredictions,
    this.gradcamHeatmapOverlay,
    this.gradcamHeatmapOnly,
    this.affectedAreaPercentage,
    this.xai,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    var predictionsJson = json['all_predictions'] as List<dynamic>? ?? [];
    List<Prediction> predictions = predictionsJson
        .map((p) => Prediction.fromJson(p as Map<String, dynamic>))
        .toList();

    return PredictionResponse(
      success: json['success'] as bool? ?? (json['predicted_class'] != null),
      predictedClass: json['predicted_class'] as String? ?? 'Unknown',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      confidencePercentage: json['confidence_percentage'] as String? ?? '0.00%',
      isFish: json['is_fish'] as bool? ?? true,
      isUncertain: json['is_uncertain'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      allPredictions: predictions,
      gradcamHeatmapOverlay: json['gradcam_heatmap_overlay'] as String?,
      gradcamHeatmapOnly: json['gradcam_heatmap_only'] as String?,
      affectedAreaPercentage:
          (json['affected_area_percentage'] as num?)?.toDouble(),
      xai: json['xai'] != null
          ? XaiExplanation.fromJson(json['xai'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Whether Grad-CAM heatmap data is available
  bool get hasGradcam =>
      gradcamHeatmapOverlay != null || gradcamHeatmapOnly != null;

  /// Whether XAI explanation data is available
  bool get hasXai => xai != null;

  /// Whether the prediction is for a healthy fish
  bool get isHealthy =>
      predictedClass.toLowerCase().contains('healthy');

  // Get top N predictions
  List<Prediction> getTopPredictions(int n) {
    if (allPredictions.length <= n) {
      return allPredictions;
    }
    return allPredictions.sublist(0, n);
  }
}

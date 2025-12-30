import 'prediction.dart';

class PredictionResponse {
  final bool success;
  final String predictedClass;
  final double confidence;
  final String confidencePercentage;
  final bool isFish;
  final bool isUncertain;
  final String message;
  final List<Prediction> allPredictions;

  PredictionResponse({
    required this.success,
    required this.predictedClass,
    required this.confidence,
    required this.confidencePercentage,
    required this.isFish,
    required this.isUncertain,
    required this.message,
    required this.allPredictions,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    var predictionsJson = json['all_predictions'] as List<dynamic>? ?? [];
    List<Prediction> predictions = predictionsJson
        .map((p) => Prediction.fromJson(p as Map<String, dynamic>))
        .toList();

    return PredictionResponse(
      success: json['success'] as bool? ?? false,
      predictedClass: json['predicted_class'] as String? ?? 'Unknown',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      confidencePercentage: json['confidence_percentage'] as String? ?? '0.00%',
      isFish: json['is_fish'] as bool? ?? false,
      isUncertain: json['is_uncertain'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      allPredictions: predictions,
    );
  }

  // Get top N predictions
  List<Prediction> getTopPredictions(int n) {
    if (allPredictions.length <= n) {
      return allPredictions;
    }
    return allPredictions.sublist(0, n);
  }
}

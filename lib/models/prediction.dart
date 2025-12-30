class Prediction {
  final String className;
  final double confidence;

  Prediction({required this.className, required this.confidence});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      className: json['class'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  String get confidencePercentage =>
      '${(confidence * 100).toStringAsFixed(2)}%';
}

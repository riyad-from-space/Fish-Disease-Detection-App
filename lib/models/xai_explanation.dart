class XaiExplanation {
  final String summary;
  final String affectedRegions;
  final String confidenceLevel;
  final String reasoning;
  final String recommendation;

  XaiExplanation({
    required this.summary,
    required this.affectedRegions,
    required this.confidenceLevel,
    required this.reasoning,
    required this.recommendation,
  });

  factory XaiExplanation.fromJson(Map<String, dynamic> json) {
    return XaiExplanation(
      summary: json['summary'] as String? ?? '',
      affectedRegions: json['affected_regions'] as String? ?? '',
      confidenceLevel: json['confidence_level'] as String? ?? '',
      reasoning: json['reasoning'] as String? ?? '',
      recommendation: json['recommendation'] as String? ?? '',
    );
  }
}

import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/prediction_response.dart';
import '../models/prediction.dart';
import '../l10n/app_localizations.dart';

class ResultsScreen extends StatefulWidget {
  final File imageFile;
  final PredictionResponse prediction;

  const ResultsScreen({
    super.key,
    required this.imageFile,
    required this.prediction,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _heatmapTabController;
  bool _xaiExpanded = true;

  // Color constants
  static const Color healthyGreen = Color(0xFF10B981);
  static const Color diseaseRed = Color(0xFFEF4444);
  static const Color lowConfidenceAmber = Color(0xFFF59E0B);
  static const Color gradcamBg = Color(0xFFFFFBEB);
  static const Color xaiBg = Color(0xFFF0F9FF);

  @override
  void initState() {
    super.initState();
    _heatmapTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _heatmapTabController.dispose();
    super.dispose();
  }

  Color _getDiagnosisColor() {
    if (widget.prediction.isHealthy) return healthyGreen;
    if (widget.prediction.confidence >= 0.7) return diseaseRed;
    return lowConfidenceAmber;
  }

  Color _getConfidenceBadgeColor(String level) {
    final lower = level.toLowerCase();
    if (lower.contains('very high') || lower.contains('high')) {
      return healthyGreen;
    } else if (lower.contains('moderate')) {
      return lowConfidenceAmber;
    }
    return diseaseRed;
  }

  Uint8List? _decodeBase64Image(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;
    try {
      return base64Decode(base64String);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final prediction = widget.prediction;
    final diagnosisColor = _getDiagnosisColor();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.analysisResults),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Warning for non-fish images
            if (!prediction.isFish) _buildNotFishWarning(l10n),

            // 1. Diagnosis Card
            _buildDiagnosisCard(prediction, diagnosisColor),

            // 2. Diagnosis Message
            if (prediction.message.isNotEmpty)
              _buildDiagnosisMessage(prediction, diagnosisColor, l10n),

            // 3. Grad-CAM Heatmap Section
            if (prediction.hasGradcam) _buildGradcamSection(prediction),

            // 4. XAI Explanation Section
            if (prediction.hasXai) _buildXaiSection(prediction),

            // 5. All Predictions
            if (prediction.allPredictions.isNotEmpty)
              _buildAllPredictions(prediction, l10n),

            // 6. Analyze Another Button
            _buildAnalyzeAnotherButton(l10n),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // Not Fish Warning
  // ==========================================================================
  Widget _buildNotFishWarning(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        border: Border.all(color: Colors.orange[700]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded,
              color: Colors.orange[700], size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.warningNotFish,
              style: TextStyle(
                color: Colors.orange[900],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 1. Diagnosis Card
  // ==========================================================================
  Widget _buildDiagnosisCard(
      PredictionResponse prediction, Color diagnosisColor) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [diagnosisColor, diagnosisColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: diagnosisColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            prediction.isHealthy ? Icons.check_circle : Icons.warning_rounded,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(height: 8),
          const Text(
            'Detected Disease',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            prediction.predictedClass,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Confidence bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: prediction.confidence,
              minHeight: 10,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            prediction.confidencePercentage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Confidence',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 2. Diagnosis Message
  // ==========================================================================
  Widget _buildDiagnosisMessage(PredictionResponse prediction,
      Color diagnosisColor, AppLocalizations l10n) {
    final bgColor = prediction.isHealthy
        ? const Color(0xFFECFDF5)
        : (prediction.confidence >= 0.7
            ? const Color(0xFFFEF2F2)
            : const Color(0xFFFFFBEB));
    final borderColor = prediction.isHealthy
        ? healthyGreen
        : (prediction.confidence >= 0.7 ? diseaseRed : lowConfidenceAmber);
    final icon = prediction.isHealthy
        ? Icons.check_circle_outline
        : Icons.medical_services_outlined;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: borderColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.translateTreatment(prediction.message),
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // 3. Grad-CAM Heatmap Section
  // ==========================================================================
  Widget _buildGradcamSection(PredictionResponse prediction) {
    final overlayBytes = _decodeBase64Image(prediction.gradcamHeatmapOverlay);
    final heatmapBytes = _decodeBase64Image(prediction.gradcamHeatmapOnly);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: gradcamBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text('🔥', style: TextStyle(fontSize: 22)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Grad-CAM Heatmap',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Affected Area Badge
          if (prediction.affectedAreaPercentage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: diseaseRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: diseaseRed.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🎯', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      '${prediction.affectedAreaPercentage!.toStringAsFixed(1)}% of image affected',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: diseaseRed.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 12),

          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: _heatmapTabController,
              labelColor: Colors.blue[700],
              unselectedLabelColor: Colors.grey[600],
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Overlay'),
                Tab(text: 'Side by Side'),
                Tab(text: 'Heatmap Only'),
              ],
            ),
          ),

          // Tab Content
          SizedBox(
            height: 300,
            child: TabBarView(
              controller: _heatmapTabController,
              children: [
                // Overlay Tab
                _buildHeatmapImage(overlayBytes, 'Overlay not available'),
                // Side by Side Tab
                _buildSideBySideView(overlayBytes),
                // Heatmap Only Tab
                _buildHeatmapImage(heatmapBytes, 'Heatmap not available'),
              ],
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Text(
              'The heatmap highlights regions the AI focused on. Red/yellow = high importance, Blue/green = less significant. The red bounding box marks the affected area.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapImage(Uint8List? imageBytes, String fallbackText) {
    if (imageBytes != null) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(imageBytes, fit: BoxFit.contain),
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            fallbackText,
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSideBySideView(Uint8List? overlayBytes) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Original',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(widget.imageFile, fit: BoxFit.contain),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Heatmap',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: overlayBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(overlayBytes,
                              fit: BoxFit.contain),
                        )
                      : Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey[400]),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 4. XAI Explanation Section
  // ==========================================================================
  Widget _buildXaiSection(PredictionResponse prediction) {
    final xai = prediction.xai!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: xaiBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header + Expand toggle
          InkWell(
            onTap: () => setState(() => _xaiExpanded = !_xaiExpanded),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('🧠', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'AI Explanation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  // Confidence Level Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          _getConfidenceBadgeColor(xai.confidenceLevel),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      xai.confidenceLevel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _xaiExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          if (_xaiExpanded) ...[
            // Summary
            if (xai.summary.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(
                  xai.summary,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey[800],
                  ),
                ),
              ),

            // Affected Regions Card
            if (xai.affectedRegions.isNotEmpty)
              _buildXaiCard(
                '📍',
                'Affected Regions',
                xai.affectedRegions,
                const Color(0xFFDCFCE7),
                const Color(0xFF16A34A),
              ),

            // Reasoning Card
            if (xai.reasoning.isNotEmpty)
              _buildXaiCard(
                '🔍',
                'Reasoning',
                xai.reasoning,
                const Color(0xFFE0F2FE),
                const Color(0xFF0284C7),
              ),

            // Recommendation Card
            if (xai.recommendation.isNotEmpty)
              _buildXaiCard(
                '💊',
                'Recommendation',
                xai.recommendation,
                const Color(0xFFFCE7F3),
                const Color(0xFFDB2777),
              ),

            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildXaiCard(
    String emoji,
    String title,
    String content,
    Color bgColor,
    Color accentColor,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accentColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // 5. All Predictions
  // ==========================================================================
  Widget _buildAllPredictions(
      PredictionResponse prediction, AppLocalizations l10n) {
    // Sort by confidence descending
    final sortedPredictions = List<Prediction>.from(prediction.allPredictions)
      ..sort((a, b) => b.confidence.compareTo(a.confidence));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📈', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                l10n.allPredictions,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Text(
                '${sortedPredictions.length} classes',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...sortedPredictions.asMap().entries.map((entry) {
            final index = entry.key;
            final pred = entry.value;
            final isTop = index == 0;
            return _buildPredictionBar(pred, isTop);
          }),
        ],
      ),
    );
  }

  Widget _buildPredictionBar(Prediction prediction, bool isTop) {
    final barColor = isTop
        ? _getDiagnosisColor()
        : (prediction.className.toLowerCase().contains('healthy')
            ? healthyGreen.withOpacity(0.6)
            : Colors.blue[400]!);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isTop ? barColor.withOpacity(0.05) : Colors.white,
        border: Border.all(
          color: isTop ? barColor.withOpacity(0.4) : Colors.grey[300]!,
          width: isTop ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: isTop
            ? [
                BoxShadow(
                  color: barColor.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (isTop)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'TOP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        prediction.className,
                        style: TextStyle(
                          fontSize: isTop ? 15 : 14,
                          fontWeight:
                              isTop ? FontWeight.bold : FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                prediction.confidencePercentage,
                style: TextStyle(
                  fontSize: isTop ? 15 : 14,
                  fontWeight: FontWeight.bold,
                  color: barColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: prediction.confidence,
              minHeight: isTop ? 8 : 6,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // 6. Analyze Another Button
  // ==========================================================================
  Widget _buildAnalyzeAnotherButton(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.camera_alt),
        label: Text(l10n.analyzeAnother),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}

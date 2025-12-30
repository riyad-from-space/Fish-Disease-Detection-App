import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('bn', ''),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App General
      'app_title': 'Fish Disease Detector',
      'language': 'Language',

      // Home Screen
      'fish_disease_detection': 'Fish Disease Detection',
      'upload_description':
          'Upload a photo of your fish to detect diseases and get treatment recommendations',
      'api_disconnected': 'API Server Disconnected',
      'current_url': 'Current URL',
      'no_image_selected': 'No image selected',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'analyze_fish': 'Analyze Fish',
      'analyzing': 'Analyzing...',
      'instructions': 'Instructions',
      'instruction_1': '1. Take a clear photo of your fish',
      'instruction_2': '2. Ensure good lighting',
      'instruction_3': '3. Focus on the affected area',
      'instruction_4': '4. Tap "Analyze Fish" button',
      'instruction_5': '5. Review the diagnosis and treatment',

      // Status Messages
      'api_connected': 'API Connected',
      'select_image_first': 'Please select an image first',
      'error_picking_image': 'Error picking image',
      'analysis_failed': 'Analysis failed',
      'selected_image': 'Selected image',
      'file_size': 'File size',
      'bytes': 'bytes',
      'file_path': 'File path',
      'selected_image_not_exist': 'Selected image file does not exist',

      // Results Screen
      'analysis_results': 'Analysis Results',
      'warning_not_fish': 'Warning: This image may not be a fish!',
      'model_uncertain': 'The model is uncertain about this prediction.',
      'detected_disease': 'Detected Disease',
      'confidence': 'Confidence',
      'treatment_recommendations': 'Treatment Recommendations',
      'all_predictions': 'All Predictions',
      'analyze_another': 'Analyze Another Image',

      // Error Messages
      'error': 'Error',
      'network_error': 'Network error occurred',
      'timeout_error': 'Request timed out',
      'unknown_error': 'An unknown error occurred',
    },
    'bn': {
      // App General
      'app_title': 'মাছের রোগ শনাক্তকারী',
      'language': 'ভাষা',

      // Home Screen
      'fish_disease_detection': 'মাছের রোগ শনাক্তকরণ',
      'upload_description':
          'মাছের রোগ শনাক্ত করতে এবং চিকিৎসার পরামর্শ পেতে আপনার মাছের ছবি আপলোড করুন',
      'api_disconnected': 'এপিআই সার্ভার সংযোগ বিচ্ছিন্ন',
      'current_url': 'বর্তমান URL',
      'no_image_selected': 'কোন ছবি নির্বাচিত হয়নি',
      'camera': 'ক্যামেরা',
      'gallery': 'গ্যালারি',
      'analyze_fish': 'মাছ বিশ্লেষণ করুন',
      'analyzing': 'বিশ্লেষণ করা হচ্ছে...',
      'instructions': 'নির্দেশাবলী',
      'instruction_1': '১. আপনার মাছের একটি পরিষ্কার ছবি তুলুন',
      'instruction_2': '২. ভাল আলো নিশ্চিত করুন',
      'instruction_3': '৩. আক্রান্ত এলাকায় ফোকাস করুন',
      'instruction_4': '৪. "মাছ বিশ্লেষণ করুন" বাটনে ট্যাপ করুন',
      'instruction_5': '৫. রোগ নির্ণয় এবং চিকিৎসা পর্যালোচনা করুন',

      // Status Messages
      'api_connected': 'এপিআই সংযুক্ত',
      'select_image_first': 'প্রথমে একটি ছবি নির্বাচন করুন',
      'error_picking_image': 'ছবি নির্বাচনে ত্রুটি',
      'analysis_failed': 'বিশ্লেষণ ব্যর্থ হয়েছে',
      'selected_image': 'নির্বাচিত ছবি',
      'file_size': 'ফাইলের আকার',
      'bytes': 'বাইট',
      'file_path': 'ফাইল পাথ',
      'selected_image_not_exist': 'নির্বাচিত ছবি ফাইল বিদ্যমান নেই',

      // Results Screen
      'analysis_results': 'বিশ্লেষণের ফলাফল',
      'warning_not_fish': 'সতর্কতা: এই ছবিটি মাছের নাও হতে পারে!',
      'model_uncertain': 'মডেলটি এই পূর্বাভাস সম্পর্কে অনিশ্চিত।',
      'detected_disease': 'শনাক্ত রোগ',
      'confidence': 'আত্মবিশ্বাস',
      'treatment_recommendations': 'চিকিৎসা সুপারিশ',
      'all_predictions': 'সমস্ত পূর্বাভাস',
      'analyze_another': 'অন্য ছবি বিশ্লেষণ করুন',

      // Error Messages
      'error': 'ত্রুটি',
      'network_error': 'নেটওয়ার্ক ত্রুটি ঘটেছে',
      'timeout_error': 'অনুরোধের সময় শেষ',
      'unknown_error': 'একটি অজানা ত্রুটি ঘটেছে',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Translate treatment message while keeping medicine names intact
  String translateTreatment(String message) {
    if (locale.languageCode != 'bn') {
      return message; // Return as-is for English
    }

    // Treatment phrase translations
    final Map<String, String> treatmentPhrases = {
      'Treatment:': 'চিকিৎসা:',
      'Use': 'ব্যবহার করুন',
      'Apply': 'প্রয়োগ করুন',
      'Administer': 'প্রয়োগ করুন',
      'Add': 'যোগ করুন',
      'Remove': 'সরান',
      'Isolate': 'আলাদা করুন',
      'the fish': 'মাছটি',
      'infected fish': 'সংক্রমিত মাছ',
      'to water': 'পানিতে',
      'to the water': 'পানিতে',
      'in water': 'পানিতে',
      'daily': 'প্রতিদিন',
      'twice daily': 'দিনে দুবার',
      'once daily': 'দিনে একবার',
      'for': 'জন্য',
      'days': 'দিন',
      'week': 'সপ্তাহ',
      'weeks': 'সপ্তাহ',
      'Maintain': 'বজায় রাখুন',
      'water temperature': 'পানির তাপমাত্রা',
      'water quality': 'পানির মান',
      'clean water': 'পরিষ্কার পানি',
      'Change': 'পরিবর্তন করুন',
      'water change': 'পানি পরিবর্তন',
      'Improve': 'উন্নত করুন',
      'diet': 'খাদ্য',
      'feeding': 'খাওয়ানো',
      'Reduce': 'কমান',
      'stress': 'চাপ',
      'Consult': 'পরামর্শ করুন',
      'veterinarian': 'পশু চিকিৎসক',
      'aquatic veterinarian': 'জলজ পশু চিকিৎসক',
      'if symptoms persist': 'লক্ষণগুলি অব্যাহত থাকলে',
      'Monitor': 'পর্যবেক্ষণ করুন',
      'closely': 'ঘনিষ্ঠভাবে',
      'Quarantine': 'কোয়ারেন্টাইন করুন',
      'new fish': 'নতুন মাছ',
      'before adding': 'যোগ করার আগে',
      'to main tank': 'মূল ট্যাংকে',
      'Increase': 'বৃদ্ধি করুন',
      'Decrease': 'হ্রাস করুন',
      'aeration': 'বায়ুচলাচল',
      'oxygen': 'অক্সিজেন',
      'salt': 'লবণ',
      'aquarium salt': 'অ্যাকুয়ারিয়াম লবণ',
      'Clean': 'পরিষ্কার করুন',
      'tank': 'ট্যাংক',
      'filter': 'ফিল্টার',
      'Avoid': 'এড়িয়ে চলুন',
      'overfeeding': 'অতিরিক্ত খাওয়ানো',
      'overcrowding': 'অতিরিক্ত ভিড়',
      'per': 'প্রতি',
      'liter': 'লিটার',
      'gallon': 'গ্যালন',
      'ml': 'মিলি',
      'grams': 'গ্রাম',
      'teaspoon': 'চা চামচ',
      'tablespoon': 'টেবিল চামচ',
    };

    String translated = message;

    // Sort by length (longest first) to avoid partial replacements
    final sortedPhrases = treatmentPhrases.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));

    for (var entry in sortedPhrases) {
      // Case-insensitive replacement
      translated = translated.replaceAllMapped(
        RegExp(entry.key, caseSensitive: false),
        (match) => entry.value,
      );
    }

    return translated;
  }

  String get appTitle => translate('app_title');
  String get language => translate('language');

  // Home Screen
  String get fishDiseaseDetection => translate('fish_disease_detection');
  String get uploadDescription => translate('upload_description');
  String get apiDisconnected => translate('api_disconnected');
  String get currentUrl => translate('current_url');
  String get noImageSelected => translate('no_image_selected');
  String get camera => translate('camera');
  String get gallery => translate('gallery');
  String get analyzeFish => translate('analyze_fish');
  String get analyzing => translate('analyzing');
  String get instructions => translate('instructions');
  String get instruction1 => translate('instruction_1');
  String get instruction2 => translate('instruction_2');
  String get instruction3 => translate('instruction_3');
  String get instruction4 => translate('instruction_4');
  String get instruction5 => translate('instruction_5');

  // Status Messages
  String get apiConnected => translate('api_connected');
  String get selectImageFirst => translate('select_image_first');
  String get errorPickingImage => translate('error_picking_image');
  String get analysisFailed => translate('analysis_failed');
  String get selectedImage => translate('selected_image');
  String get fileSize => translate('file_size');
  String get bytes => translate('bytes');
  String get filePath => translate('file_path');
  String get selectedImageNotExist => translate('selected_image_not_exist');

  // Results Screen
  String get analysisResults => translate('analysis_results');
  String get warningNotFish => translate('warning_not_fish');
  String get modelUncertain => translate('model_uncertain');
  String get detectedDisease => translate('detected_disease');
  String get confidence => translate('confidence');
  String get treatmentRecommendations => translate('treatment_recommendations');
  String get allPredictions => translate('all_predictions');
  String get analyzeAnother => translate('analyze_another');

  // Error Messages
  String get error => translate('error');
  String get networkError => translate('network_error');
  String get timeoutError => translate('timeout_error');
  String get unknownError => translate('unknown_error');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'bn'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

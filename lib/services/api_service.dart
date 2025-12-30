import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import '../models/prediction_response.dart';
import '../config/api_config.dart';

class ApiService {
  // Get the appropriate base URL based on platform
  static String get baseUrl {
    if (Platform.isAndroid) {
      // For real device, use local network URL
      // For emulator, you might want to use androidEmulatorUrl
      return ApiConfig.localNetworkUrl;
    } else if (Platform.isIOS) {
      // For iOS simulator, use localhost
      return ApiConfig.iosSimulatorUrl;
    }
    return ApiConfig.localNetworkUrl;
  }

  // You can manually set the base URL if needed
  static String? customBaseUrl;

  static String get _effectiveBaseUrl => customBaseUrl ?? baseUrl;

  // Timeout duration for API calls
  static Duration get _timeoutDuration =>
      Duration(seconds: ApiConfig.timeoutSeconds);

  /// Check if the API server is healthy
  static Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$_effectiveBaseUrl${ApiConfig.healthEndpoint}'))
          .timeout(_timeoutDuration);

      return response.statusCode == 200;
    } catch (e) {
      if (ApiConfig.debugMode) {
        print('Health check failed: $e');
      }
      return false;
    }
  }

  /// Get all disease classes from the API
  static Future<List<String>> getClasses() async {
    try {
      final response = await http
          .get(Uri.parse('$_effectiveBaseUrl${ApiConfig.classesEndpoint}'))
          .timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['classes'] ?? []);
      } else {
        throw Exception('Failed to load classes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching classes: $e');
    }
  }

  /// Upload an image and get disease prediction
  static Future<PredictionResponse> predictDisease(File imageFile) async {
    try {
      // Verify file exists
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_effectiveBaseUrl${ApiConfig.predictEndpoint}'),
      );

      // Add headers
      request.headers['Accept'] = 'application/json';

      // Determine content type from file extension
      String fileName = path.basename(imageFile.path);
      String fileExtension = path.extension(fileName).toLowerCase();

      // If no extension or unrecognized, try to detect from file
      if (fileExtension.isEmpty || fileExtension == '.tmp') {
        // Default to jpg for images without extension
        fileName = 'image.jpg';
        fileExtension = '.jpg';
      }

      // Map file extension to MIME type
      String contentType = 'image/jpeg'; // default
      if (fileExtension == '.png') {
        contentType = 'image/png';
      } else if (fileExtension == '.jpg' || fileExtension == '.jpeg') {
        contentType = 'image/jpeg';
      } else if (fileExtension == '.gif') {
        contentType = 'image/gif';
      } else if (fileExtension == '.webp') {
        contentType = 'image/webp';
      } else if (fileExtension == '.heic' || fileExtension == '.heif') {
        contentType = 'image/heic';
      }

      if (ApiConfig.debugMode) {
        print('Original file path: ${imageFile.path}');
        print('Uploading file: $fileName');
        print('File extension: $fileExtension');
        print('File size: ${await imageFile.length()} bytes');
        print('Content-Type: $contentType');
        print('URL: $_effectiveBaseUrl${ApiConfig.predictEndpoint}');
      }

      // Read file bytes first to ensure it's valid
      final bytes = await imageFile.readAsBytes();

      if (ApiConfig.debugMode) {
        print('Successfully read ${bytes.length} bytes from file');
      }

      // Add the image file to the request with proper content type
      var multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
        contentType: MediaType.parse(contentType),
      );
      request.files.add(multipartFile);

      if (ApiConfig.debugMode) {
        print('Multipart file details:');
        print('  Field name: ${multipartFile.field}');
        print('  Filename: ${multipartFile.filename}');
        print('  Content-Type: ${multipartFile.contentType}');
        print('  Length: ${multipartFile.length}');
      }

      // Send the request
      var streamedResponse = await request.send().timeout(_timeoutDuration);
      var response = await http.Response.fromStream(streamedResponse);

      if (ApiConfig.debugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PredictionResponse.fromJson(data);
      } else {
        throw Exception(
          'Prediction failed with status: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error predicting disease: $e');
    }
  }

  /// Test connection with different base URLs
  static Future<String?> findWorkingUrl() async {
    final urls = [
      ApiConfig.localNetworkUrl,
      ApiConfig.androidEmulatorUrl,
      ApiConfig.iosSimulatorUrl,
    ];

    for (var url in urls) {
      try {
        final response = await http
            .get(Uri.parse('$url${ApiConfig.healthEndpoint}'))
            .timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          return url;
        }
      } catch (e) {
        continue;
      }
    }
    return null;
  }
}

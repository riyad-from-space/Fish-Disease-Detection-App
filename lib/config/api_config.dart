/// API Configuration
///
/// Update these values to match your FastAPI backend server configuration

class ApiConfig {
  // ============================================================================
  // CONFIGURE YOUR BACKEND SERVER URL HERE
  // ============================================================================

  /// Local network URL - for real devices on same WiFi network
  /// Example: Your computer's local IP address
  static const String localNetworkUrl = 'http://192.168.1.151:8000';

  /// Android emulator URL - use this for Android emulator
  /// 10.0.2.2 is the special alias to your host loopback interface
  static const String androidEmulatorUrl = 'http://10.0.2.2:8000';

  /// iOS simulator URL - use this for iOS simulator
  /// localhost works directly in iOS simulator
  static const String iosSimulatorUrl = 'http://localhost:8000';

  /// Public URL - for production server
  /// Use this for accessing backend from anywhere
  static const String publicUrl = 'https://fish-disease-detector.onrender.com';

  // ============================================================================
  // ADVANCED SETTINGS (usually don't need to change)
  // ============================================================================

  /// Request timeout in seconds
  static const int timeoutSeconds = 30;

  /// Enable debug logging
  static const bool debugMode = true;

  /// Maximum image size (in pixels) before upload
  /// Larger images will be compressed
  static const int maxImageWidth = 1024;
  static const int maxImageHeight = 1024;

  /// Image quality (0-100)
  /// Lower = smaller file size, faster upload, less quality
  static const int imageQuality = 85;

  // ============================================================================
  // API ENDPOINTS (shouldn't need to change unless backend API changes)
  // ============================================================================

  static const String healthEndpoint = '/health';
  static const String predictEndpoint = '/predict';
  static const String classesEndpoint = '/classes';
}

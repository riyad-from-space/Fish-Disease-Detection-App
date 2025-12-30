# Fish Disease Detector

A Flutter mobile application that uses AI to detect fish diseases through image analysis. The app connects to a FastAPI backend server to perform disease prediction and provide treatment recommendations.

## Features

- 📷 **Image Capture**: Take photos directly from camera or select from gallery
- 🔍 **Disease Detection**: AI-powered disease identification
- 📊 **Confidence Scores**: Visual representation of prediction confidence
- 💊 **Treatment Recommendations**: Get actionable treatment advice
- ⚠️ **Non-fish Detection**: Warns if uploaded image is not a fish
- 🌐 **Real-time API Status**: Monitor connection to backend server
- 🎨 **Modern UI**: Clean, medical-themed Material Design interface

## API Configuration

The app connects to your local FastAPI server. Update the base URL in `lib/services/api_service.dart` if needed:

- **Local Network**: `http://192.168.0.150:8000` (for real devices)
- **Android Emulator**: `http://10.0.2.2:8000`
- **iOS Simulator**: `http://localhost:8000`

### API Endpoints Used

1. `GET /health` - Check API server status
2. `POST /predict` - Upload fish image for disease prediction
3. `GET /classes` - Retrieve all disease classes

## Setup Instructions

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- FastAPI backend server running

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure platform-specific permissions (see below)

### Android Configuration

Add camera and storage permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Add these permissions -->
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <application
        android:label="Fish Disease Detector"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true">
        <!-- ... rest of configuration ... -->
    </application>
</manifest>
```

**Note**: `android:usesCleartextTraffic="true"` allows HTTP connections (needed for local server).

### iOS Configuration

Add camera and photo library permissions to `ios/Runner/Info.plist`:

```xml
<dict>
    <!-- Add these entries -->
    <key>NSCameraUsageDescription</key>
    <string>This app needs camera access to take photos of fish for disease detection</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>This app needs photo library access to select fish images for disease detection</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>This app needs microphone access for video recording</string>
    
    <!-- ... rest of configuration ... -->
</dict>
```

### Web Configuration (Optional)

For web support, no additional configuration is needed for the API calls. However, camera access may be limited based on browser capabilities.

## Running the App

1. **Start your FastAPI backend server** first

2. **Run the Flutter app**:
   ```bash
   # For development
   flutter run
   
   # For specific platform
   flutter run -d android
   flutter run -d ios
   flutter run -d chrome
   ```

3. **Build for release**:
   ```bash
   flutter build apk          # Android APK
   flutter build appbundle    # Android App Bundle
   flutter build ios          # iOS
   ```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   ├── prediction.dart          # Prediction data model
│   └── prediction_response.dart # API response model
├── screens/
│   ├── home_screen.dart         # Main screen with image upload
│   └── results_screen.dart      # Results display screen
└── services/
    └── api_service.dart         # API communication service
```

## Dependencies

- `http: ^1.1.0` - HTTP requests to backend API
- `image_picker: ^1.0.4` - Camera and gallery image selection
- `path: ^1.8.3` - File path manipulation
- `cupertino_icons: ^1.0.8` - iOS-style icons

## Usage Guide

1. **Launch the app** - Check API connection status in top-right corner
2. **Select image source** - Choose Camera or Gallery
3. **Take/Select photo** - Capture or pick a fish image
4. **Analyze** - Tap "Analyze Fish" button
5. **View results** - See disease prediction, confidence, and treatment recommendations

## Troubleshooting

### API Connection Issues

- Verify FastAPI server is running
- Check if device/emulator is on the same network
- For Android emulator, use `10.0.2.2` instead of `localhost`
- For iOS simulator, use `localhost:8000`
- Check firewall settings

### Permission Issues

- Grant camera permissions when prompted
- Grant storage/photo library permissions
- Reinstall app if permissions are denied permanently

### Image Upload Fails

- Check image file size (large images may timeout)
- Ensure stable network connection
- Verify API endpoint is correct
- Check backend server logs

## API Response Format

```json
{
  "success": true,
  "predicted_class": "Bacterial Gill Disease",
  "confidence": 0.85,
  "confidence_percentage": "85.00%",
  "is_fish": true,
  "is_uncertain": false,
  "message": "Treatment recommendation...",
  "all_predictions": [
    {"class": "Bacterial Gill Disease", "confidence": 0.85},
    {"class": "Healthy", "confidence": 0.10},
    {"class": "Fungal Infection", "confidence": 0.05}
  ]
}
```

## Future Enhancements

- [ ] Offline disease database
- [ ] History of analyzed images
- [ ] Export results as PDF
- [ ] Multi-language support
- [ ] Dark mode theme
- [ ] Share results with veterinarians

## License

This project is for educational purposes.

## Support

For issues and questions, please contact your system administrator or refer to the FastAPI backend documentation.

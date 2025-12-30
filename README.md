# 🐟 Fish Disease Detector

A Flutter mobile application that uses AI to detect fish diseases through image analysis. Connect your smartphone to a FastAPI backend server for real-time disease prediction and treatment recommendations.

![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green)

## ✨ Features

- 📷 **Camera & Gallery Integration** - Capture or select fish images
- 🤖 **AI Disease Detection** - Connect to FastAPI ML backend
- 📊 **Confidence Visualization** - See prediction confidence with progress bars
- 💊 **Treatment Recommendations** - Get actionable treatment advice
- ⚠️ **Smart Warnings** - Detects non-fish images and uncertain predictions
- 🌐 **API Health Monitoring** - Real-time connection status
- 🎨 **Modern UI** - Clean Material Design with medical theme
- 🔄 **Error Handling** - Robust network and error management

## 📸 Screenshots

```
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│   Home Screen   │  │   Analyzing     │  │    Results      │
│                 │  │                 │  │                 │
│  [Fish Icon]    │  │  [Image]        │  │  [Image]        │
│                 │  │                 │  │                 │
│  Select Image:  │  │  Analyzing...   │  │  Disease Name   │
│  [Camera] [📁]  │  │  ⚙️ Loading     │  │  85.00%         │
│                 │  │                 │  │                 │
│  [Analyze Fish] │  │                 │  │  💊 Treatment   │
│                 │  │                 │  │  📊 Top 3       │
└─────────────────┘  └─────────────────┘  └─────────────────┘
```

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Android Studio / Xcode
- FastAPI backend server running

### Installation

```bash
# Clone or navigate to project
cd "/Users/riyadafromspace/Documents/Fish Disease Predictor and Treatement/fish_disease_predictor"

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Configure API

Edit `lib/config/api_config.dart`:

```dart
static const String localNetworkUrl = 'http://YOUR_IP:8000';
```

## 📚 Documentation

- **[QUICK_START.md](QUICK_START.md)** - Get started in minutes
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Detailed setup instructions
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Complete project overview
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Technical architecture details

## 🏗️ Project Structure

```
lib/
├── config/
│   └── api_config.dart          # 🔧 API configuration
├── models/
│   ├── prediction.dart          # Prediction data model
│   └── prediction_response.dart # API response model
├── screens/
│   ├── home_screen.dart         # Main upload screen
│   └── results_screen.dart      # Results display
├── services/
│   └── api_service.dart         # API communication
└── main.dart                    # App entry point
```

## 🔌 API Integration

### Base URLs

- **Local Network**: `http://192.168.0.150:8000` (real devices)
- **Android Emulator**: `http://10.0.2.2:8000`
- **iOS Simulator**: `http://localhost:8000`

### Endpoints

1. `GET /health` - Check server status
2. `POST /predict` - Upload image for prediction
3. `GET /classes` - Get disease classes

### Example Response

```json
{
  "success": true,
  "predicted_class": "Bacterial Gill Disease",
  "confidence": 0.85,
  "confidence_percentage": "85.00%",
  "is_fish": true,
  "is_uncertain": false,
  "message": "Treatment: Use antibiotics...",
  "all_predictions": [
    {"class": "Bacterial Gill Disease", "confidence": 0.85},
    {"class": "Healthy", "confidence": 0.10}
  ]
}
```

## 📦 Dependencies

```yaml
dependencies:
  http: ^1.1.0          # API requests
  image_picker: ^1.0.4  # Camera/gallery
  path: ^1.8.3          # File paths
```

## 🎨 Theme & Design

- **Primary Color**: Blue (#1976D2) - Medical/professional
- **Design System**: Material Design 3
- **Typography**: Clear, readable fonts
- **Components**: Cards, buttons, progress bars

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📱 Building

### Android

```bash
# APK
flutter build apk --release

# App Bundle (Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Build
flutter build ios --release

# Then archive in Xcode
open ios/Runner.xcworkspace
```

## 🔧 Configuration Options

### API Settings (`lib/config/api_config.dart`)

```dart
static const String localNetworkUrl = 'http://192.168.0.150:8000';
static const int timeoutSeconds = 30;
static const int maxImageWidth = 1024;
static const int maxImageHeight = 1024;
static const int imageQuality = 85;
static const bool debugMode = true;
```

## ⚠️ Troubleshooting

### API Not Connecting

1. Verify backend server is running
2. Check device is on same WiFi network
3. Update URL in `lib/config/api_config.dart`
4. For emulator, use `10.0.2.2` (Android) or `localhost` (iOS)

### Camera/Gallery Issues

1. Grant permissions when prompted
2. Check `AndroidManifest.xml` and `Info.plist`
3. Reinstall app if needed

### Upload Fails

1. Check image size (max 1024x1024)
2. Verify network connection
3. Check backend server logs
4. Increase timeout if needed

## 💡 Usage Tips

1. **Good Lighting** - Take photos in well-lit areas
2. **Clear Focus** - Ensure fish is in focus
3. **Close Up** - Get close to affected areas
4. **Stable Network** - Use WiFi for faster uploads
5. **Fresh Images** - Recent, clear images work best

## 🔐 Permissions

### Android (`AndroidManifest.xml`)
- ✅ Camera
- ✅ Storage (Read/Write)
- ✅ Internet
- ✅ Cleartext Traffic

### iOS (`Info.plist`)
- ✅ Camera Usage
- ✅ Photo Library Usage
- ✅ Microphone Usage

## 🛠️ Development

### Run in Development

```bash
flutter run

# Hot reload: press 'r'
# Hot restart: press 'R'
# Quit: press 'q'
```

### Debug Mode

Set `debugMode = true` in `api_config.dart` to enable console logs.

### Format Code

```bash
flutter format lib/
```

### Analyze Code

```bash
flutter analyze
```

## 📊 Features Checklist

- ✅ Camera image capture
- ✅ Gallery image selection
- ✅ Image preview with clear option
- ✅ API health status indicator
- ✅ Loading states during analysis
- ✅ Disease name display
- ✅ Confidence percentage
- ✅ Treatment recommendations
- ✅ Top 3 predictions with progress bars
- ✅ Non-fish image warning
- ✅ Uncertainty warning
- ✅ Network error handling
- ✅ Modern Material Design UI
- ✅ Platform-specific URL handling

## 🎯 Roadmap

- [ ] Save analysis history
- [ ] Export results as PDF
- [ ] Share results
- [ ] Offline database
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Image annotation
- [ ] Batch processing

## 🤝 Contributing

This is a private project for fish disease detection. For issues or improvements:

1. Review existing documentation
2. Check troubleshooting guide
3. Verify API configuration
4. Test with sample images

## 📄 License

This project is for educational and research purposes.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for UI/UX guidelines
- FastAPI for the backend framework

## 📞 Support

- Check documentation in the `docs` folder
- Review `QUICK_START.md` for common tasks
- See `ARCHITECTURE.md` for technical details
- Use Flutter DevTools for debugging

## 🎓 Learn More

- [Flutter Documentation](https://flutter.dev/docs)
- [Material Design](https://material.io/design)
- [Image Picker Plugin](https://pub.dev/packages/image_picker)
- [HTTP Package](https://pub.dev/packages/http)

---

**Built with ❤️ using Flutter**

**Happy Fish Disease Detection! 🐟📱**


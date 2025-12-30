# Quick Start Guide - Fish Disease Detector

## 🚀 Getting Started

### 1. Start Your Backend Server
Make sure your FastAPI server is running on your local network:
```bash
# Your FastAPI server should be accessible at:
# http://192.168.0.150:8000
```

### 2. Run the App
```bash
cd "/Users/riyadafromspace/Documents/Fish Disease Predictor and Treatement/fish_disease_predictor"

# Run on connected device or emulator
flutter run

# Or specify platform
flutter run -d android    # For Android
flutter run -d ios        # For iOS
```

## 📱 Using the App

1. **Check API Status**
   - Look at the icon in the top-right corner of the app
   - ✅ Green checkmark = Connected
   - ❌ Red error = Disconnected (tap to retry)

2. **Capture Fish Image**
   - Tap **Camera** to take a new photo
   - Tap **Gallery** to select existing photo
   - Make sure the image shows the fish clearly

3. **Analyze**
   - Tap **Analyze Fish** button
   - Wait for the analysis (loading indicator will show)
   - Results will appear automatically

4. **View Results**
   - See the detected disease name
   - Check confidence percentage
   - Read treatment recommendations
   - View all top predictions with confidence bars

## 🔧 Configuration

### Change API URL

If your backend is on a different address, update `lib/services/api_service.dart`:

```dart
// Line ~7-9 in api_service.dart
static const String _localNetworkUrl = 'http://YOUR_IP:8000';
```

### Platform-Specific URLs

The app automatically uses the right URL:
- **Real Android Device**: Uses local network URL (192.168.0.150:8000)
- **Android Emulator**: Uses 10.0.2.2:8000
- **iOS Simulator**: Uses localhost:8000

## ⚠️ Troubleshooting

### "API Server Disconnected" Message

1. **Check if backend is running**
   ```bash
   # Test in terminal
   curl http://192.168.0.150:8000/health
   ```

2. **Verify network connection**
   - Device and computer must be on same WiFi
   - Check firewall settings

3. **For Android Emulator**
   - Use `http://10.0.2.2:8000` instead
   - Update in `api_service.dart` if needed

4. **For iOS Simulator**
   - Use `http://localhost:8000`
   - Make sure backend binds to 0.0.0.0, not 127.0.0.1

### Camera/Gallery Not Working

1. **Grant permissions**
   - Allow camera access when prompted
   - Allow photo library access when prompted

2. **Reinstall if needed**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### Analysis Fails

1. **Check image size** - Very large images may timeout
2. **Verify network** - Ensure stable connection
3. **Check backend logs** - See what error occurred on server

## 📊 Understanding Results

### Confidence Score
- **85-100%**: Very confident prediction
- **70-85%**: Good confidence
- **50-70%**: Uncertain (warning shown)
- **<50%**: Low confidence

### Warning Messages
- **"Not a fish"**: Image doesn't appear to be a fish
- **"Uncertain prediction"**: Confidence is too low

### Top Predictions
- Shows top 3 disease predictions
- Each with confidence percentage
- Visual progress bars for easy comparison

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   ├── prediction.dart          # Single prediction model
│   └── prediction_response.dart # Full API response model
├── screens/
│   ├── home_screen.dart         # Main upload screen
│   └── results_screen.dart      # Results display
└── services/
    └── api_service.dart         # API communication
```

## 🧪 Testing

Run the basic smoke test:
```bash
flutter test
```

## 📦 Building Release Version

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (requires macOS)
```bash
flutter build ios --release
# Then open in Xcode to archive and distribute
```

## 🎯 Features Checklist

- ✅ Camera image capture
- ✅ Gallery image selection
- ✅ Image preview with clear option
- ✅ API health check indicator
- ✅ Loading states during analysis
- ✅ Disease name display
- ✅ Confidence percentage
- ✅ Treatment recommendations
- ✅ Top 3 predictions with bars
- ✅ Non-fish image warning
- ✅ Uncertainty warning
- ✅ Network error handling
- ✅ Modern Material Design UI
- ✅ Blue medical theme

## 💡 Tips for Best Results

1. **Good Lighting**: Take photos in well-lit areas
2. **Clear Focus**: Make sure fish is in focus
3. **Close Up**: Get close to affected area
4. **Stable Connection**: Use WiFi for faster uploads
5. **Fresh Photos**: Recent, clear images work best

## 🔐 Permissions Required

### Android
- Camera
- Storage (Read/Write)
- Internet

### iOS  
- Camera
- Photo Library
- Internet

These are automatically requested on first use.

## 📞 Need Help?

- Check backend server logs for API errors
- Use Flutter DevTools for debugging
- Review `SETUP_GUIDE.md` for detailed setup
- Check that all dependencies are installed

## 🎨 Customization

### Change Theme Colors
Edit `lib/main.dart`:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.blue,  // Change this color
),
```

### Change App Name
Edit platform-specific files:
- Android: `android/app/src/main/AndroidManifest.xml`
- iOS: `ios/Runner/Info.plist`

---

**Happy Fish Disease Detection! 🐟**

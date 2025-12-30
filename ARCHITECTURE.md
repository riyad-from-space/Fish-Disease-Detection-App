# 🏗️ App Architecture Overview

## Application Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                         MAIN APP                                 │
│                      (lib/main.dart)                             │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  FishDiseaseDetectorApp (MaterialApp)                   │   │
│  │  - Blue Medical Theme                                    │   │
│  │  - Material Design 3                                     │   │
│  └──────────────────────┬──────────────────────────────────┘   │
└─────────────────────────┼────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                      HOME SCREEN                                 │
│                 (screens/home_screen.dart)                       │
│                                                                   │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  🎯 Features:                                           │    │
│  │  • API Health Status Indicator                         │    │
│  │  • Camera / Gallery Image Picker                       │    │
│  │  • Image Preview with Clear Option                     │    │
│  │  • Analyze Button with Loading State                   │    │
│  │  • Error Messages                                       │    │
│  │  • Instructions Card                                    │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                   │
│  User Actions:                                                   │
│  1️⃣ Select Image (Camera/Gallery) → _pickImage()               │
│  2️⃣ Preview Image → Display in Container                       │
│  3️⃣ Analyze Fish → _analyzeImage()                             │
│                          │                                       │
└──────────────────────────┼───────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                       API SERVICE                                │
│                 (services/api_service.dart)                      │
│                                                                   │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  🔌 API Methods:                                        │    │
│  │                                                          │    │
│  │  checkHealth()                                          │    │
│  │  └─→ GET /health                                        │    │
│  │                                                          │    │
│  │  predictDisease(File image)                            │    │
│  │  └─→ POST /predict (multipart/form-data)               │    │
│  │                                                          │    │
│  │  getClasses()                                           │    │
│  │  └─→ GET /classes                                       │    │
│  │                                                          │    │
│  │  findWorkingUrl()                                       │    │
│  │  └─→ Auto-detect API server                            │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                   │
│  Configuration from: lib/config/api_config.dart                 │
│  • Base URLs (network/emulator/simulator)                       │
│  • Timeout: 30 seconds                                          │
│  • Endpoints                                                     │
│                          │                                       │
└──────────────────────────┼───────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                     FASTAPI BACKEND                              │
│                  (http://192.168.0.150:8000)                     │
│                                                                   │
│  • Image processing                                             │
│  • AI/ML disease detection                                      │
│  • Returns prediction response                                  │
│                          │                                       │
└──────────────────────────┼───────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                   PREDICTION RESPONSE                            │
│            (models/prediction_response.dart)                     │
│                                                                   │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  📊 Response Data:                                      │    │
│  │  • success: bool                                        │    │
│  │  • predicted_class: String                             │    │
│  │  • confidence: double                                   │    │
│  │  • confidence_percentage: String                       │    │
│  │  • is_fish: bool                                        │    │
│  │  • is_uncertain: bool                                   │    │
│  │  • message: String (treatment)                         │    │
│  │  • all_predictions: List<Prediction>                   │    │
│  └────────────────────────────────────────────────────────┘    │
│                          │                                       │
└──────────────────────────┼───────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                     RESULTS SCREEN                               │
│                (screens/results_screen.dart)                     │
│                                                                   │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  🎯 Display Components:                                 │    │
│  │                                                          │    │
│  │  📸 Image Preview                                       │    │
│  │  └─→ Full-size image                                    │    │
│  │                                                          │    │
│  │  ⚠️ Warnings (if applicable)                            │    │
│  │  ├─→ Non-fish image warning                            │    │
│  │  └─→ Uncertain prediction warning                      │    │
│  │                                                          │    │
│  │  🏥 Main Prediction Card                                │    │
│  │  ├─→ Disease name                                       │    │
│  │  └─→ Confidence percentage (large)                     │    │
│  │                                                          │    │
│  │  💊 Treatment Recommendations                           │    │
│  │  └─→ Text from API message field                       │    │
│  │                                                          │    │
│  │  📊 Top 3 Predictions                                   │    │
│  │  ├─→ Prediction 1 with progress bar                    │    │
│  │  ├─→ Prediction 2 with progress bar                    │    │
│  │  └─→ Prediction 3 with progress bar                    │    │
│  │                                                          │    │
│  │  🔄 Analyze Another Image Button                        │    │
│  │  └─→ Navigate back to home screen                      │    │
│  └────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

## Data Flow Diagram

```
┌──────────┐      ┌──────────┐      ┌──────────┐      ┌──────────┐
│  User    │ ──→  │  Image   │ ──→  │   API    │ ──→  │ Backend  │
│  Action  │      │  Picker  │      │ Service  │      │  Server  │
└──────────┘      └──────────┘      └──────────┘      └──────────┘
     │                  │                  │                  │
     │                  │                  │                  ▼
     │                  │                  │            ┌──────────┐
     │                  │                  │            │    AI    │
     │                  │                  │            │  Model   │
     │                  │                  │            └──────────┘
     │                  │                  │                  │
     │                  │                  ▼                  ▼
     │                  │            ┌──────────┐      ┌──────────┐
     │                  │            │   HTTP   │ ←──  │  JSON    │
     │                  │            │ Response │      │ Response │
     │                  │            └──────────┘      └──────────┘
     │                  │                  │
     │                  ▼                  ▼
     │            ┌──────────┐      ┌──────────┐
     │            │   File   │      │ Response │
     │            │  Object  │      │  Model   │
     │            └──────────┘      └──────────┘
     │                  │                  │
     ▼                  ▼                  ▼
┌──────────────────────────────────────────────┐
│           RESULTS SCREEN                      │
│  • Disease Name                               │
│  • Confidence Score                           │
│  • Treatment Advice                           │
│  • All Predictions                            │
└──────────────────────────────────────────────┘
```

## State Management

```
HomeScreen State:
├─ _selectedImage: File?           (selected image)
├─ _isLoading: bool                (API call in progress)
├─ _isHealthy: bool                (API server status)
└─ _errorMessage: String?          (error display)

Operations:
├─ _checkApiHealth()               (on init & manual refresh)
├─ _pickImage(source)              (camera/gallery)
├─ _analyzeImage()                 (upload & predict)
└─ _clearImage()                   (reset selection)
```

## Configuration Hierarchy

```
api_config.dart (Central Configuration)
      │
      ├─→ API URLs
      │   ├─ localNetworkUrl: "http://192.168.0.150:8000"
      │   ├─ androidEmulatorUrl: "http://10.0.2.2:8000"
      │   └─ iosSimulatorUrl: "http://localhost:8000"
      │
      ├─→ Settings
      │   ├─ timeoutSeconds: 30
      │   ├─ debugMode: true
      │   ├─ maxImageWidth: 1024
      │   ├─ maxImageHeight: 1024
      │   └─ imageQuality: 85
      │
      └─→ Endpoints
          ├─ healthEndpoint: "/health"
          ├─ predictEndpoint: "/predict"
          └─ classesEndpoint: "/classes"
```

## Model Structure

```
Prediction
├─ className: String
├─ confidence: double
└─ confidencePercentage: String (getter)

PredictionResponse
├─ success: bool
├─ predictedClass: String
├─ confidence: double
├─ confidencePercentage: String
├─ isFish: bool
├─ isUncertain: bool
├─ message: String
├─ allPredictions: List<Prediction>
└─ getTopPredictions(n): List<Prediction> (method)
```

## UI Component Tree

```
Scaffold
├─ AppBar
│  ├─ Title: "Fish Disease Detector"
│  └─ Action: Health Status Icon
│
└─ Body (SingleChildScrollView)
   ├─ Header Card (Gradient)
   │  ├─ Fish Icon
   │  ├─ Title
   │  └─ Description
   │
   ├─ API Status Warning (if disconnected)
   │
   ├─ Image Preview Container
   │  ├─ Selected Image (if any)
   │  │  └─ Clear Button (X)
   │  └─ Placeholder (if none)
   │
   ├─ Action Buttons Row
   │  ├─ Camera Button
   │  └─ Gallery Button
   │
   ├─ Analyze Button
   │  └─ Loading Indicator (when analyzing)
   │
   ├─ Error Message (if any)
   │
   └─ Instructions Card
      └─ 5 Instruction Items
```

## Results Screen Component Tree

```
Scaffold
├─ AppBar
│  └─ Title: "Analysis Results"
│
└─ Body (SingleChildScrollView)
   ├─ Image Display (300px height)
   │
   ├─ Non-Fish Warning (if !is_fish)
   │  └─ Warning Icon + Message
   │
   ├─ Uncertainty Warning (if is_uncertain)
   │  └─ Info Icon + Message
   │
   ├─ Main Prediction Card (Gradient)
   │  ├─ "Detected Disease" label
   │  ├─ Disease Name (large)
   │  ├─ Confidence Percentage (huge)
   │  └─ "Confidence" label
   │
   ├─ Treatment Recommendations
   │  └─ Medical Icon + Message Text
   │
   ├─ Top 3 Predictions
   │  ├─ Prediction Card 1
   │  │  ├─ Class Name + Percentage
   │  │  └─ Progress Bar (blue dark)
   │  ├─ Prediction Card 2
   │  │  ├─ Class Name + Percentage
   │  │  └─ Progress Bar (blue medium)
   │  └─ Prediction Card 3
   │     ├─ Class Name + Percentage
   │     └─ Progress Bar (blue light)
   │
   └─ Analyze Another Image Button
```

## Error Handling Flow

```
                ┌─────────────┐
                │   Action    │
                └──────┬──────┘
                       │
                       ▼
              ┌────────────────┐
              │  Try-Catch     │
              │  Block         │
              └───┬────────┬───┘
                  │        │
        Success ◄─┘        └─► Error
           │                    │
           ▼                    ▼
    ┌──────────┐         ┌──────────┐
    │ Process  │         │ Catch    │
    │ Result   │         │ Exception│
    └──────────┘         └────┬─────┘
                              │
                              ▼
                       ┌──────────┐
                       │ Set Error│
                       │ Message  │
                       └────┬─────┘
                            │
                            ▼
                     ┌──────────┐
                     │ Display  │
                     │ to User  │
                     └──────────┘
```

## Platform Detection Logic

```
if (Platform.isAndroid)
    └─→ Use ApiConfig.localNetworkUrl
        (for real device on WiFi)

else if (Platform.isIOS)
    └─→ Use ApiConfig.iosSimulatorUrl
        (localhost for simulator)

else
    └─→ Default to localNetworkUrl
```

## Image Upload Process

```
1. User selects image
   └─→ ImagePicker.pickImage()
       ├─ Apply maxWidth: 1024
       ├─ Apply maxHeight: 1024
       └─ Apply imageQuality: 85

2. Create File object
   └─→ File(image.path)

3. Create multipart request
   ├─→ POST to /predict
   ├─→ Add file with field name 'file'
   └─→ Set filename from path

4. Send request with timeout
   └─→ 30 second timeout

5. Receive response
   ├─→ Success (200)
   │   └─→ Parse JSON to PredictionResponse
   └─→ Error
       └─→ Throw exception with message

6. Navigate to results
   └─→ Pass File and PredictionResponse
```

## Theme Colors

```
Primary Theme: BLUE (Medical/Professional)

┌─────────────────────────────────────┐
│ Colors.blue[700]  #1976D2  ████████ │  AppBar, Primary Button
│ Colors.blue[600]  #1E88E5  ████████ │  Buttons
│ Colors.blue[500]  #2196F3  ████████ │  Gradient
│ Colors.blue[400]  #42A5F5  ████████ │  Gradient, Progress Bar
│ Colors.blue[300]  #64B5F6  ████████ │  Progress Bar
├─────────────────────────────────────┤
│ Colors.green[600] #43A047  ████████ │  Analyze Button, Success
│ Colors.orange[700] #F57C00 ████████ │  Warning (non-fish)
│ Colors.amber[900] #FF6F00  ████████ │  Warning (uncertain)
│ Colors.red[700]  #D32F2F  ████████ │  Error, Disconnect
└─────────────────────────────────────┘
```

---

**This architecture provides a clean, maintainable, and user-friendly fish disease detection application!** 🐟✨

# New BBB App

A modern Flutter application with login functionality and a comprehensive dashboard, deployable on Web, Android, and iOS platforms.

## Features

- **Modern UI/UX**: Beautiful Material Design 3 interface with gradient backgrounds and smooth animations
- **Authentication**: Secure login system with form validation
- **Dashboard**: Comprehensive dashboard with statistics, recent activity, and navigation
- **Cross-Platform**: Deployable on Web, Android, and iOS
- **Responsive Design**: Adapts to different screen sizes and orientations

## Screenshots

### Login Screen
- Modern gradient background
- Form validation for email and password
- Loading states and error handling
- Demo credentials hint

### Dashboard
- Welcome section with gradient card
- Quick stats with colorful stat cards
- Recent activity feed
- Toggleable navigation drawer
- Logout functionality

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code (recommended for development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/HandsomeRocks/vibe_coding_flutter.git
   cd vibe_coding_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**

   **For Web:**
   ```bash
   flutter run -d chrome
   ```

   **For Android:**
   ```bash
   flutter run -d android
   ```

   **For iOS:**
   ```bash
   flutter run -d ios
   ```

## Demo Credentials

For testing purposes, you can use any valid email format and a password with at least 6 characters:

- **Email**: `test@example.com`
- **Password**: `123456`

## Project Structure

```
lib/
├── main.dart              # App entry point
├── screens/
│   ├── login_screen.dart  # Login screen with form validation
│   └── dashboard_screen.dart # Main dashboard with navigation
├── services/
│   └── auth_service.dart  # Authentication service
└── widgets/
    ├── dashboard_card.dart # Activity card widget
    └── stat_card.dart     # Statistics card widget
```

## Building for Production

### Web
```bash
flutter build web
```

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Google Play Store Deployment

### Prerequisites for Google Play Store
1. **Google Play Console Account**: Sign up at [Google Play Console](https://play.google.com/console)
2. **App Signing**: Set up app signing in Google Play Console
3. **Privacy Policy**: Create a privacy policy for your app
4. **App Content Rating**: Complete the content rating questionnaire

### Generate App Bundle (Recommended for Google Play Store)
The Android App Bundle (AAB) is the recommended format for Google Play Store as it creates optimized APKs for different device configurations.

```bash
# Generate release app bundle
flutter build appbundle --release

# The output will be located at:
# build/app/outputs/bundle/release/app-release.aab
```

### Generate APK (Alternative)
If you need a traditional APK file:

```bash
# Generate release APK
flutter build apk --release

# Generate split APKs for different architectures
flutter build apk --split-per-abi --release

# The outputs will be located at:
# build/app/outputs/flutter-apk/app-release.apk
# build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
# build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
# build/app/outputs/flutter-apk/app-x86_64-release.apk
```

### Testing the Build
Before uploading to Google Play Store, test your build:

```bash
# Install the APK on a connected device
flutter install --release

# Or install the app bundle (requires bundletool)
# First, download bundletool from: https://github.com/google/bundletool
# Then convert AAB to APK for testing:
# java -jar bundletool.jar build-apks --bundle=app-release.aab --output=app-release.apks
```

### Upload to Google Play Store
1. **Sign in** to [Google Play Console](https://play.google.com/console)
2. **Create a new app** or select existing app
3. **Go to Production** track
4. **Create new release**
5. **Upload** your `.aab` file (recommended) or `.apk` file
6. **Add release notes** describing your changes
7. **Review and roll out** to production

### App Bundle Benefits
- **Smaller download sizes**: Users download only the code they need
- **Optimized for device**: Automatic optimization for different screen densities and CPU architectures
- **Faster downloads**: Reduced bandwidth usage
- **Better performance**: Optimized for each device type

### Version Management
Update your app version in `pubspec.yaml`:

```yaml
version: 1.0.0+1  # version_name + version_code
```

- **version_name**: User-visible version (1.0.0)
- **version_code**: Internal version number for Google Play Store (1)

## Customization

### Colors
The app uses Material Design 3 color scheme. You can customize colors in `lib/main.dart`:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  useMaterial3: true,
),
```

### Authentication
The current authentication is simulated. To integrate with a real backend:

1. Update `lib/services/auth_service.dart`
2. Replace the mock authentication with your API calls
3. Add proper error handling and user management

## Dependencies

- `flutter`: Core Flutter framework
- `cupertino_icons`: iOS-style icons

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support and questions, please open an issue in the repository.

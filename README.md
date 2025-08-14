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
- Bottom navigation with multiple tabs
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
   git clone <repository-url>
   cd new_bbb_app
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

# Delleni Government Papers Guide App

A comprehensive Flutter application that serves as a guide for government papers. This app helps users access, understand, and navigate official government documentation with ease.

## 📋 Project Overview

Delleni is a multi-platform Flutter application that guides users through government services. It centralizes required papers, procedural steps, nearby offices, and community advice, running on Android, iOS, Web, Windows, Linux, and macOS.

## 🚀 Features

- **Service Guides**: Required papers and step-by-step checklists with per-user progress saved in Hive.
- **Community Tips**: Commenting, likes/dislikes, and aggregated discussions per service via Supabase.
- **Locations & Directions**: Office listings per service, distance hints, and external map directions using geolocator/url_launcher.
- **Searchable Catalog**: Service list is searchable and kept in sync from Supabase.
- **Cross-Platform Support**: Android, iOS, Web, Windows, Linux, macOS.
- **Real-time Sync**: Supabase-backed data for services, locations, and comments.
- **Local Storage**: Hive for offline-ready progress tracking; SharedPreferences for lightweight settings.

## 🛠️ Tech Stack

- **Framework**: Flutter 3.9.2+
- **State Management**: GetX 4.7.3
- **Backend**: Supabase Flutter 2.10.3
- **Local Storage**: Hive 2.2.3, SharedPreferences 2.5.3
- **Location Services**: Geolocator 14.0.2, Geocoding 4.0.0
- **Other**: intl, url_launcher, flutter_native_splash

## 🧭 Architecture

- **Clean-ish Layers**: `features/*` split into data, domain, usecases, and presentation (controllers/pages).
- **GetX**: Bindings + controllers manage DI and state; part files keep `ServiceController` organized (services, progress, locations, comments).
- **Data Sources**: Supabase for remote CRUD; Hive for offline progress cache per user/service.
- **UI**: Feature-first pages (home, service detail, locations, comments, progress) with reusable cards and sheets.

## 📁 Project Structure

```
delleni_app/
├── lib/                          # Dart source code
│   ├── main.dart                # Application entry point
│   └── app/                     # App-specific folders
├── assets/                      # Static assets (images, fonts, etc.)
├── android/                     # Android-specific code
├── ios/                         # iOS-specific code
├── web/                         # Web platform files
├── windows/                     # Windows platform files
├── linux/                       # Linux platform files
├── macos/                       # macOS platform files
├── test/                        # Unit and widget tests
├── pubspec.yaml                 # Flutter dependencies and metadata
└── README.md                    # This file
```

## ⚙️ Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK 3.9.2 or higher
- Android SDK (for Android development)
- Xcode (for iOS development)
- Visual Studio or MinGW (for Windows development)

## 🔧 Installation & Setup

### 1. Clone the Repository
```bash
git clone <repository-url>
cd DEPI_Grad
```

### 2. Install Dependencies
Navigate to the delleni_app directory and get dependencies:
```bash
cd delleni_app
flutter pub get
```

### 3. Configure Supabase
- Set Supabase URL and anon/public key in your client provider (see `lib/core/supabase_client_provider.dart`).
- Ensure `services`, `locations`, `comments`, and `users` tables exist with expected columns.

### 4. Configure Native Splash Screen
```bash
flutter pub run flutter_native_splash:create
```

## 🚀 Running the App

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d iphone
```

### Web
```bash
flutter run -d chrome
```

### Windows
```bash
flutter run -d windows
```

### Linux
```bash
flutter run -d linux
```

### macOS
```bash
flutter run -d macos
```

## 📦 Building for Release

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

### Windows
```bash
flutter build windows --release
```

### Linux
```bash
flutter build linux --release
```

### macOS
```bash
flutter build macos --release
```

## 🔐 Configuration

### Supabase Setup
- Create a Supabase project at https://supabase.com
- Configure your Supabase credentials in the app initialization
- Update the Supabase URL and API key in your environment configuration

### Location Services
- Ensure location permissions are properly configured in platform-specific settings:
  - **Android**: `AndroidManifest.xml`
  - **iOS**: `Info.plist`

## 🧪 Testing

Run tests using:
```bash
flutter test
```

## 🔍 Quick Dev Notes

- Services, comments, and locations are fetched from Supabase; ensure network + auth tokens are valid.
- User progress is keyed by `userId_serviceId` in the Hive box `user_progress`.
- Map directions rely on device/location permissions; fallbacks show destination search if origin is unknown.

## 📝 Dependencies

Key packages used in this project:
- **GetX**: State management and navigation
- **Supabase Flutter**: Backend services and real-time database
- **Hive**: Local NoSQL database
- **Geolocator**: Device location services
- **Geocoding**: Convert between coordinates and addresses
- **URL Launcher**: Open URLs and handle deep links

## 🤝 Contributing

1. Create a feature branch (`git checkout -b feature/amazing-feature`)
2. Commit your changes (`git commit -m 'Add amazing feature'`)
3. Push to the branch (`git push origin feature/amazing-feature`)
4. Open a Pull Request

## 📄 License

This project is private and not publicly distributed.

## 📞 Support

For issues, questions, or suggestions, please create an issue in the project repository.

## 🔄 Version History

- **v1.0.0**: Initial release

---

**Last Updated**: December 2025

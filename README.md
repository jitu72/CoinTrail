# 💰 Expanse Tracker App

A modern, feature-rich Flutter expense tracking application that helps users manage their finances with ease. Built with clean architecture and local data storage for complete offline functionality.

## 📱 Features

### ✨ Core Functionality
- **💳 Transaction Management**: Add, edit, and delete income/expense transactions
- **📊 Financial Dashboard**: Real-time balance tracking and spending insights
- **📈 Statistics & Charts**: Visual representation of spending patterns by category
- **🏷️ Category Organization**: Predefined categories for better expense classification
- **🔍 Transaction History**: Comprehensive view of all financial activities
- **💾 Local Storage**: Complete offline functionality using SharedPreferences

### 🎨 User Experience
- **🌙 Modern UI**: Clean, intuitive interface with smooth animations
- **📱 Responsive Design**: Optimized for various screen sizes
- **🚀 Fast Performance**: Lightweight app with instant data access
- **🔒 Privacy First**: No cloud dependencies, all data stays on device
- **🎯 No Authentication**: Instant access without signup requirements

## 🛠️ Technical Stack

### Frontend
- **Flutter 3.32.7**: Cross-platform mobile development
- **Dart 3.8.1**: Programming language
- **GetX**: State management and navigation
- **Material Design**: UI components and theming

### Data & Storage
- **SharedPreferences**: Local key-value storage
- **JSON Serialization**: Data persistence and retrieval
- **Local Data Service**: Custom service layer for data management

### Key Packages
```yaml
dependencies:
  flutter: sdk
  get: ^4.6.6                    # State management
  shared_preferences: ^2.2.3     # Local storage
  intl: ^0.19.0                  # Date formatting
  syncfusion_flutter_charts: ^27.1.50  # Charts
  lottie: ^3.1.0                 # Animations
  flutter_svg: ^2.0.10+1         # SVG icons
  iconsax: ^0.0.8                # Icon library
```

## 🏗️ Architecture

### Project Structure
```
lib/
├── controller/           # Business logic & state management
│   ├── home_controller/  # Dashboard functionality
│   ├── wallet_controller/# Transaction management
│   └── auth_controller/  # User registration (simplified)
├── model/               # Data models
│   ├── transaction_model.dart
│   └── categories_model.dart
├── services/            # Service layer
│   └── local_data_service.dart
├── view/                # UI screens
│   ├── home/           # Dashboard screens
│   ├── wallet/         # Transaction screens
│   └── auth/           # Login/register (optional)
├── widgets/             # Reusable components
└── routes/              # Navigation setup
```

### Design Patterns
- **MVC Architecture**: Clean separation of concerns
- **Service Layer Pattern**: Centralized data management
- **Repository Pattern**: Data access abstraction
- **Observer Pattern**: Reactive state management with GetX

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- Android emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/jitu72/Expanse-Tracker-App.git
   cd Expanse-Tracker-App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Build for Release
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release
```

## 🔧 Configuration

### Sample Data
The app automatically initializes with sample transactions on first launch:
- Monthly salary (Income): $2000
- Grocery shopping (Expense): $50
- Coffee purchase (Expense): $5

### Customization
- **Categories**: Modify categories in `lib/model/categories_model.dart`
- **Colors**: Update app theme in `lib/config/app_color.dart`
- **Sample Data**: Adjust in `lib/services/local_data_service.dart`

## 🔄 Data Flow

1. **User Input** → Transaction Form
2. **Validation** → Controller Layer
3. **Processing** → Local Data Service
4. **Storage** → SharedPreferences
5. **State Update** → GetX Controllers
6. **UI Refresh** → Reactive Widgets

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widget_test.dart
```

## 📱 Platform Support

| Platform | Status |
|----------|---------|
| Android  | ✅ Fully Supported |
| iOS      | ✅ Fully Supported |
| Web      | ✅ Supported |
| Windows  | ✅ Supported |
| macOS    | ✅ Supported |
| Linux    | ✅ Supported |

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team**: For the amazing framework
- **GetX Community**: For excellent state management
- **Material Design**: For UI/UX guidelines
- **Syncfusion**: For beautiful chart components

## 📞 Contact

**Jihadul Islam**
- GitHub: [@jitu72](https://github.com/jitu72)
- Email: jihadulislam.jitu72@gmail.com

---

⭐ **Star this repository if you found it helpful!**

*Built with ❤️ using Flutter*

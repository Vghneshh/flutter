# Daily Journal App 📖

A beautiful and responsive Flutter application for daily journaling with emotion tracking and Firebase integration.

## Features ✨

- **Emotion Tracking**: Track your daily emotions with beautiful emojis and color-coded system
- **Beautiful UI**: Modern, responsive design with smooth animations
- **Firebase Integration**: Secure authentication and cloud storage
- **Analytics**: View your emotion patterns and journaling statistics
- **User Profiles**: Personalize your experience with user profiles
- **Tags System**: Organize your entries with custom tags
- **Word Count**: Track your writing progress
- **Cross-Platform**: Works on Android, iOS, Web, and Desktop

## Emotions Supported 😊

- 😊 Happy
- 😢 Sad
- 😠 Angry
- 😐 Neutral
- 🤩 Excited
- 😰 Anxious
- 🙏 Grateful
- 😤 Frustrated

## Screenshots 📱

### Authentication
- Beautiful login and signup screens with form validation
- Smooth animations and error handling

### Journal Entry
- Emotion selection with emoji grid
- Rich text input for your thoughts
- Tag system for organization
- Word count tracking

### Home Screen
- Recent journal entries with emotion indicators
- Quick access to create new entries
- Beautiful card-based layout

### Analytics
- Emotion distribution charts
- Writing statistics
- Recent activity tracking
- Visual progress indicators

### Profile
- User statistics and achievements
- Settings and preferences
- Account management

## Getting Started 🚀

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd daily_journal_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Enable Authentication (Email/Password)
   - Enable Firestore Database
   - Download and add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Update the Firebase configuration in `lib/firebase_options.dart`

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure 📁

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/
│   ├── user_model.dart       # User data model
│   └── journal_entry.dart    # Journal entry model
├── providers/
│   ├── auth_provider.dart    # Authentication state management
│   └── journal_provider.dart # Journal data management
└── screens/
    ├── splash_screen.dart    # App splash screen
    ├── auth/
    │   ├── login_screen.dart # Login screen
    │   └── signup_screen.dart # Signup screen
    ├── home_screen.dart      # Main home screen
    ├── journal_entry_screen.dart # New entry screen
    ├── emotion_stats_screen.dart # Analytics screen
    └── profile_screen.dart   # User profile screen
```

## Dependencies 📦

### Core Dependencies
- `flutter`: Flutter framework
- `firebase_core`: Firebase core functionality
- `firebase_auth`: Firebase authentication
- `cloud_firestore`: Firestore database
- `provider`: State management

### UI Dependencies
- `google_fonts`: Beautiful typography
- `flutter_animate`: Smooth animations
- `fl_chart`: Charts and analytics
- `shimmer`: Loading animations

### Utility Dependencies
- `intl`: Internationalization and date formatting
- `uuid`: Unique ID generation
- `shared_preferences`: Local storage
- `image_picker`: Image selection
- `path_provider`: File system access

## Firebase Configuration 🔥

### Authentication
- Email/Password authentication enabled
- User profile management
- Secure sign-in/sign-out

### Firestore Collections
- `users`: User profile data
- `journal_entries`: Journal entries with emotion tracking

### Security Rules
```javascript
// Example Firestore security rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /journal_entries/{entryId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
  }
}
```

## Features in Detail 🎯

### Emotion Tracking
- 8 different emotions with unique colors and emojis
- Visual emotion selection grid
- Emotion-based analytics and insights

### Journal Management
- Create, read, update, and delete entries
- Rich text input with word count
- Tag system for organization
- Date and time tracking

### Analytics Dashboard
- Emotion distribution pie charts
- Writing statistics and trends
- Recent activity feed
- Progress tracking

### User Experience
- Smooth animations and transitions
- Responsive design for all screen sizes
- Intuitive navigation
- Error handling and validation

## Contributing 🤝

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support 💬

If you have any questions or need help, please open an issue on GitHub or contact the development team.

## Acknowledgments 🙏

- Flutter team for the amazing framework
- Firebase for backend services
- The open-source community for the wonderful packages

---

**Made with ❤️ using Flutter and Firebase**

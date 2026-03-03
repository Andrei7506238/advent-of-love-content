# Love Messages - Flutter App

A beautifully designed Flutter app for creating, editing, and managing love messages with images. Perfect for creating daily love notes with images sourced from Pexels or Unsplash APIs.

## ✨ Features

### Core Functionality
- 📅 **Calendar Date Picker** - Select any date for your messages
- 💬 **Rich Text Input** - Write beautiful love messages
- 🖼️ **Image Search** - Search images from Pexels or Unsplash
- 📱 **Mobile-First Design** - Optimized for phone use
- 💾 **Local Storage** - Messages saved locally as JSON
- 📤 **Export** - Download all messages as JSON file
- 📥 **Import** - Load messages from JSON file

## 🏗️ Architecture

Clean architecture with separation of concerns:
- **Models**: Data structures
- **Repositories**: Abstract interfaces + concrete implementations
- **Cubits**: Business logic and state management
- **Screens**: UI layer with no business logic

Key patterns:
- Repository Pattern (generic `ImageRepository` interface)
- BLoC/Cubit Pattern (all logic in cubits)
- Dependency Injection (constructor-based)

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.11+
- Dart SDK

### Installation

1. **Install dependencies**
   ```bash
   cd aol_manager
   flutter pub get
   ```

2. **Get API Key**
   - Visit [pexels.com/api](https://www.pexels.com/api/)
   - Or [unsplash.com/oauth/applications](https://unsplash.com/oauth/applications)

3. **Configure API**
   
   Edit `lib/config/api_config.dart`:
   ```dart
   static const String pexelsApiKey = 'YOUR_API_KEY_HERE';
   ```

4. **Run**
   ```bash
   flutter run
   ```

## 📖 Usage

- **Create**: Tap + button, pick date, write message, search image
- **Edit**: Tap pencil icon on message card, modify, update
- **Delete**: Tap trash icon, confirm
- **Export**: Tap download icon, choose location
- **Import**: Tap upload icon, select JSON file

## 📚 Documentation

- [SETUP_GUIDE.md](SETUP_GUIDE.md) - Detailed setup instructions
- [API_KEYS_GUIDE.md](API_KEYS_GUIDE.md) - API key configuration

## 📄 Project Structure

```
lib/
├── config/           # Configuration
├── data/
│   ├── models/      # Message, ImageResult
│   └── repositories/ # ImageRepository, PexelsRepository, etc.
├── presentation/
│   ├── cubits/      # MessagesCubit, ImageSearchCubit, etc.
│   └── screens/     # HomeScreen, MessageEditorScreen, etc.
└── main.dart
```

## 🧪 Code Quality

- No UI logic (all in cubits)
- Dependency injection throughout
- Generic repository interfaces
- Comprehensive error handling
- Full null safety

## 📱 Features

- Calendar date selector
- Real-time message validation
- Image search with pagination
- Local JSON storage
- Import/export functionality
- Photographer attribution

## 🔒 Security

- API keys never committed
- URLs stored only (no local image caching)
- Local JSON in secure app directory

## 🎯 Future Ideas

- Image caching
- Message templates
- Cloud sync
- Share to social media
- Dark mode
- Multiple languages

## 📝 License

MIT - Free for personal and commercial use

## 📞 Support

Check the documentation files for detailed setup and troubleshooting.


# Love Messages - Flutter App

A beautiful Flutter app for creating, editing, and managing love messages with images. Perfect for creating daily love notes with images from Pexels or Unsplash.

## Features

✨ **Core Features**
- 📅 Calendar date picker for selecting message dates
- 💬 Rich text input for love messages
- 🖼️ Image search integration with Pexels and Unsplash
- 📱 Mobile-friendly responsive design
- 💾 Local JSON file storage
- 📤 Export messages as JSON
- 📥 Import messages from JSON files

## Architecture

This project follows clean architecture principles with clear separation of concerns:

### Project Structure
```
lib/
├── data/
│   ├── models/              # Data models
│   │   ├── message_model.dart
│   │   └── image_result_model.dart
│   └── repositories/        # Repository interfaces & implementations
│       ├── image_repository.dart
│       ├── pexels_repository.dart
│       ├── unsplash_repository.dart
│       └── file_repository.dart
├── presentation/
│   ├── cubits/              # State management (BLoC)
│   │   ├── messages_cubit.dart
│   │   ├── image_search_cubit.dart
│   │   └── message_editor_cubit.dart
│   └── screens/             # UI screens
│       ├── home_screen.dart
│       ├── message_editor_screen.dart
│       └── image_search_screen.dart
└── main.dart                # App entry point
```

### Key Design Patterns

1. **Repository Pattern**: Generic `ImageRepository` interface with concrete implementations for Pexels and Unsplash
2. **BLoC/Cubit Pattern**: All business logic handled in cubits, UI is logic-free
3. **Separation of Concerns**: Clear layers (data, presentation)
4. **Dependency Injection**: Dependencies passed via constructors

## Setup Instructions

### Prerequisites
- Flutter SDK 3.11+
- Dart SDK
- IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1. **Clone the repository**
   ```bash
   cd aol_manager
   flutter pub get
   ```

2. **Get API Keys** (Required for image search)

   #### Pexels API Key
   - Visit [pexels.com/api](https://www.pexels.com/api)
   - Sign up for a free account
   - Create a new API key
   - Copy your API key

   #### Unsplash API Key (Optional)
   - Visit [unsplash.com/oauth/applications](https://unsplash.com/oauth/applications)
   - Create a new application
   - Copy your Access Key

3. **Configure API Keys**

   Open `lib/main.dart` and replace the placeholder:
   ```dart
   // Line 20 - Replace with your actual Pexels API key
   const String pexelsApiKey = 'YOUR_PEXELS_API_KEY_HERE';
   
   // To use Unsplash instead:
   import 'package:aol_manager/data/repositories/unsplash_repository.dart';
   final imageRepository = UnsplashRepository(apiKey: 'YOUR_UNSPLASH_API_KEY_HERE');
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Usage

### Creating a Message

1. **Tap** the floating action button or "New Message"
2. **Select a date** by tapping the date field (calendar will appear)
3. **Write your message** in the text area
4. **Select an image** by tapping "Search Image"
   - Search for keywords (e.g., "love", "heart", "couple")
   - Tap any image to select it
5. **Create** the message by tapping the Create button

### Editing a Message

1. **Tap** the edit icon (✏️) on any message card
2. **Modify** the date, message, or image
3. **Update** by tapping the Update button

### Deleting a Message

1. **Tap** the delete icon (🗑️) on any message card
2. **Confirm** the deletion in the dialog

### Exporting Messages

1. **Tap** the download icon (⬇️) in the app bar
2. **Select** a location to save the JSON file
3. Messages are saved as a JSON array

### Importing Messages

1. **Tap** the upload icon (⬆️) in the app bar
2. **Select** a previously exported JSON file
3. Imported messages are added to existing ones

## JSON Format

Messages are stored in the following JSON format:

```json
[
  {
    "date": "2025-08-13",
    "content": "Tu ești motivul pentru care zâmbesc...",
    "image": "https://plus.unsplash.com/premium_photo..."
  },
  {
    "date": "2025-08-14",
    "content": "Mi-aș dori să fiu lângă tine...",
    "image": "https://image.spreadshirtmedia.net/..."
  }
]
```

## State Management

### MessagesCubit
Manages the list of all messages:
- Load messages from storage
- Add new messages
- Update existing messages
- Delete messages
- Import/Export functionality

### MessageEditorCubit
Manages the current message being edited:
- Set date, content, image
- Validate message completeness
- Reset state

### ImageSearchCubit
Manages image search:
- Search images from selected repository
- Pagination support
- Error handling
- Loading states

## Dependencies

- **flutter_bloc**: State management
- **table_calendar**: Calendar widget (can be added if needed)
- **http**: HTTP requests to image APIs
- **intl**: Date formatting
- **file_picker**: File import/export
- **path_provider**: Local file storage
- **google_fonts**: Beautiful typography

## API Considerations

### Rate Limits

**Pexels:**
- Free Plan: 200 requests/hour
- Perfect for personal use

**Unsplash:**
- Free Plan: 50 requests/hour
- Production apps need rate validation

## Future Enhancements

- [ ] Offline image caching
- [ ] Multiple image repositories with tab switching
- [ ] Rich text editor
- [ ] Message templates
- [ ] Sharing functionality
- [ ] Cloud backup
- [ ] Image cropping/editing

## Troubleshooting

### Image Search Not Working
- Verify API key is correct in `main.dart`
- Check internet connection
- Confirm API rate limits haven't been exceeded
- Check Pexels/Unsplash API status

### Messages Not Saving
- Verify app has file write permissions
- Check device storage space
- Ensure app data folder is accessible

### Import/Export Issues
- Verify JSON file format matches the schema
- Check file permissions
- Ensure valid JSON syntax

## License

MIT License - Feel free to use and modify for personal use.

## Support

For issues or questions, please refer to the code comments and architecture documentation in the source files.

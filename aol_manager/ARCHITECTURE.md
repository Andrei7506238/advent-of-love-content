# Architecture Documentation

## Overview

This Flutter application demonstrates **Clean Architecture** with clear separation between presentation, business logic, and data layers. The architecture emphasizes maintainability, testability, and extensibility.

## Layered Architecture

```
┌─────────────────────────────────┐
│    PRESENTATION LAYER           │
│  (Screens, UserInteraction)     │
└──────────────┬──────────────────┘
               │
┌──────────────▼──────────────────┐
│  STATE MANAGEMENT LAYER         │
│  (Cubits - BusinessLogic)       │
└──────────────┬──────────────────┘
               │
┌──────────────▼──────────────────┐
│    DATA LAYER                   │
│  (Repositories, Models, APIs)   │
└─────────────────────────────────┘
```

## Layer Details

### 1. Presentation Layer

**Location**: `lib/presentation/`

Responsibilities:
- UI rendering
- User interaction handling
- Displaying data to users
- Navigation between screens

**Key principle**: **NO BUSINESS LOGIC**

All logic is delegated to cubits. Presentation code should only:
- Render UI based on state
- Call cubit methods on user interaction
- Display loading/error states

**Files**:
- `screens/` - Full page widgets
- `widgets/` - Reusable UI components

### 2. State Management Layer

**Location**: `lib/presentation/cubits/`

Technology: **Flutter Bloc/Cubit**

`Cubit` is a simplified version of Bloc without events.

#### MessagesCubit
```dart
// Manages: List of all messages
// Methods:
- loadMessages()     // Load from storage
- addMessage()       // Add new message
- updateMessage()    // Edit message
- deleteMessage()    // Remove message
- importMessages()   // Bulk import
- exportMessages()   // Export to file
```

#### ImageSearchCubit
```dart
// Manages: Image search results and pagination
// Methods:
- searchImages()     // Search with query
- loadMore()         // Pagination
```

#### MessageEditorCubit
```dart
// Manages: Current message being edited
// Methods:
- setDate()          // Update date
- setContent()       // Update message text
- setImage()         // Update image URL
- setMessage()       // Set all fields
- reset()            // Clear all
- isValid()          // Validation
```

### 3. Data Layer

**Location**: `lib/data/`

Responsibilities:
- Data models
- Repository abstractions
- API integrations
- Local storage

#### 3a. Models

**Files**: `models/`

Data structures that:
- Define entity structure
- Implement serialization (toJson/fromJson)
- Support copying with modifications

Example:
```dart
class Message {
  final DateTime date;
  final String content;
  final String image;
  
  // JSON serialization
  Map<String, dynamic> toJson() { ... }
  factory Message.fromJson(Map json) { ... }
  
  // Immutability support
  Message copyWith({...}) { ... }
}
```

#### 3b. Repositories

**Files**: `repositories/`

**Pattern**: Repository Pattern

```
ImageRepository (Abstract Interface)
    ↓
    ├── PexelsRepository (Implementation)
    └── UnsplashRepository (Implementation)

FileRepository (Concrete Class)
```

**Benefits**:
- Swappable implementations
- Easy to test (mock repositories)
- Consistent interface across data sources
- Decoupled from UI

Example:
```dart
// Abstract interface
abstract class ImageRepository {
  Future<List<ImageResult>> searchImages(String query, int page);
  String getSourceName();
}

// Concrete implementation
class PexelsRepository implements ImageRepository {
  final String _apiKey;
  
  @override
  Future<List<ImageResult>> searchImages(...) async {
    // Pexels API logic
  }
}
```

## Data Flow

### Creating a Message

```
User taps "Create"
        ↓
MessageEditorScreen
        ↓
MessageEditorCubit.isValid()
        ↓
Call MessagesCubit.addMessage()
        ↓
MessagesCubit calls FileRepository.saveMessages()
        ↓
FileRepository writes JSON to disk
        ↓
MessagesCubit emits new state
        ↓
Screens rebuild with new message
```

### Searching Images

```
User enters search term
        ↓
ImageSearchScreen calls ImageSearchCubit.searchImages()
        ↓
ImageSearchCubit calls ImageRepository.searchImages()
        ↓
PexelsRepository makes HTTP request
        ↓
Parse JSON response to List<ImageResult>
        ↓
ImageSearchCubit emits new state
        ↓
ImageSearchScreen displays images in grid
        ↓
User taps image
        ↓
MessageEditorCubit.setImage(imageUrl)
        ↓
ImageSearchScreen pops off navigation stack
```

## Dependency Injection

Dependencies are passed through constructors:

```dart
// In main.dart
final fileRepository = FileRepository();
final imageRepository = PexelsRepository(apiKey: 'key');

BlocProvider(
  create: (context) => MessagesCubit(
    fileRepository: fileRepository,
  ),
),
```

**Benefits**:
- Dependencies are explicit
- Easy to test with mocks
- Flexible configuration
- No service locator needed

## Adding New Features

### Example: Add Message Favorites

#### 1. Update Model
```dart
class Message {
  final DateTime date;
  final String content;
  final String image;
  final bool isFavorite;  // NEW
}
```

#### 2. Create Cubit
```dart
class FavoritesCubit extends Cubit<FavoritesState> {
  final MessagesCubit _messagesCubit;
  
  void toggleFavorite(int index) {
    // Logic here
  }
}
```

#### 3. Add Repository Method
```dart
abstract class FileRepository {
  Future<void> saveFavorites(List<int> favoriteIndices);
  Future<List<int>> loadFavorites();
}
```

#### 4. UI Integration
```dart
BlocBuilder<FavoritesCubit, FavoritesState>(
  builder: (context, state) {
    // Show UI with favorites
  },
)
```

## Testing Strategy

### Unit Testing Cubits

```dart
test('should add message to list', () async {
  // Arrange
  final mockFileRepo = MockFileRepository();
  final cubit = MessagesCubit(fileRepository: mockFileRepo);
  
  // Act
  await cubit.addMessage(testMessage);
  
  // Assert
  expect(cubit.state.messages.length, 1);
  verify(mockFileRepo.saveMessages(any)).called(1);
});
```

### Mock Repositories

```dart
class MockPexelsRepository implements ImageRepository {
  @override
  Future<List<ImageResult>> searchImages(...) async {
    return [testImageResult];
  }
}
```

## Error Handling

Each layer handles errors appropriately:

### Presentation Layer
- Shows error snackbars
- Updates UI with error states
- Provides retry mechanisms

### Cubit Layer
- Catches exceptions from repositories
- Emits error states
- Provides meaningful error messages

### Data Layer
- Throws specific exceptions
- Handles API errors
- Logs critical failures

## Configuration Management

**File**: `lib/config/api_config.dart`

```dart
class ApiConfig {
  static const String pexelsApiKey = 'YOUR_KEY';
  static const String unsplashApiKey = 'YOUR_KEY';
  static const String defaultImageSource = 'pexels';
  
  // Add more config as needed
  static const Duration requestTimeout = Duration(seconds: 30);
  static const int paginationPageSize = 20;
}
```

## Extending the App

### Add New Image Source

1. Create repository implementing `ImageRepository`
2. Inject in `main.dart`
3. Update UI to allow selection

### Add Message Filtering

1. Add filter state to `MessagesCubit`
2. Add filter methods
3. Update `HomeScreen` UI

### Add Cloud Sync

1. Create `CloudRepository` implementing `FileRepository`
2. Add to dependency injection
3. Update cubits to use cloud repository

## State Immutability

Cubits return immutable states to ensure:
- Predictable state changes
- Easy debugging
- Safe concurrent access

```dart
// Immutable state
class MessageEditorState {
  final Message message;
  
  const MessageEditorState({required this.message});
  
  // Create new state without modifying original
  MessageEditorState copyWith({Message? message}) {
    return MessageEditorState(
      message: message ?? this.message,
    );
  }
}
```

## Performance Considerations

### Image Loading
- Thumbnails loaded initially
- Full images available on demand
- Network errors handled gracefully

### Pagination
- Implemented for image search
- Loads 20 items per page
- Detects end of results

### Message Storage
- JSON file persisted locally
- Loaded once on app start
- Rebuilt on each modification

### State Management
- Cubits rebuild only affected widgets
- No unnecessary rebuilds
- Efficient state comparisons

## Best Practices Applied

✅ **Single Responsibility Principle**
- Each class has one reason to change
- Clear, focused responsibilities

✅ **Open/Closed Principle**
- Open for extension (add repositories)
- Closed for modification (interfaces stable)

✅ **Liskov Substitution Principle**
- Repositories interchangeable
- Consistent contract across implementations

✅ **Interface Segregation Principle**
- Specific interfaces (ImageRepository)
- Clients depend on what they use

✅ **Dependency Inversion Principle**
- Depend on abstractions not concrete classes
- Easy to swap implementations

## Conclusion

This architecture prioritizes:
1. **Maintainability** - Clear structure and responsibilities
2. **Testability** - Dependency injection throughout
3. **Scalability** - Easy to add features
4. **Flexibility** - Swappable implementations
5. **Clean Code** - SOLID principles applied

The codebase serves as a template for building robust, professional Flutter applications.

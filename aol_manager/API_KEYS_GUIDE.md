# How to Configure API Keys for Image Search

This guide explains how to set up the image search functionality with either Pexels or Unsplash (or both).

## Step 1: Choose Your Image Provider

The app supports two free image APIs:

### Option A: Pexels (Recommended for Beginners)
- **URL**: https://www.pexels.com/api/
- **Rate Limit**: 200 requests/hour (free)
- **Setup Time**: ~2 minutes
- **Quality**: Excellent curated photos

### Option B: Unsplash
- **URL**: https://unsplash.com/oauth/applications
- **Rate Limit**: 50 requests/hour (free)
- **Setup Time**: ~5 minutes
- **Quality**: Premium community photos

## Step 2: Get Your API Key

### For Pexels:

1. Visit https://www.pexels.com/api/
2. Click "Generate API Key" button
3. You'll see your API key displayed
4. Copy it completely

### For Unsplash:

1. Visit https://unsplash.com/oauth/applications
2. Log in or create account
3. Click "Create a new application"
4. Accept terms and create
5. Copy your "Access Key" from the application details

## Step 3: Add API Key to Configuration

1. Open `lib/config/api_config.dart`
2. Replace `YOUR_PEXELS_API_KEY_HERE` with your actual key:

```dart
static const String pexelsApiKey = 'YOUR_ACTUAL_KEY_HERE';
```

Example:
```dart
static const String pexelsApiKey = 'g1a2b3c4d5e6f7h8i9j0k1l2m3n4o5p6';
```

## Step 4: Select Default Service

In the same `api_config.dart` file, choose your default service:

```dart
static const String defaultImageSource = 'pexels'; // or 'unsplash'
```

## Step 5: Test the App

1. Run the app: `flutter run`
2. Create a new message
3. Click "Search Image"
4. Try searching for "love"
5. If images appear, configuration is successful!

## Troubleshooting

### "Failed to load images" error:
- Check that API key is correct (copy-paste carefully)
- Verify no extra spaces before/after the key
- Ensure internet connection is active
- Check that you haven't exceeded rate limits

### Images not showing in results:
- Try a different search term
- Wait an hour if you've made many requests
- Check API key permissions in the provider's dashboard

### App crashes on image search:
- Ensure `api_config.dart` has valid API keys
- Check Flutter/Dart version matches requirements
- Run `flutter clean && flutter pub get`

## Multiple Services

To use both services, you can:

1. Add both API keys to `api_config.dart`:
```dart
static const String pexelsApiKey = 'your_pexels_key';
static const String unsplashApiKey = 'your_unsplash_key';
```

2. Modify `main.dart` to provide both repositories:
```dart
// Create a repository selector based on user preference
final imageRepository = ApiConfig.defaultImageSource == 'pexels'
    ? PexelsRepository(apiKey: ApiConfig.pexelsApiKey)
    : UnsplashRepository(apiKey: ApiConfig.unsplashApiKey);
```

## Security Note

- Never commit your API keys to version control
- If you share code, use environment variables or a `.gitignore` file
- For production apps, consider using a backend to proxy API calls
- Rotate keys periodically in provider dashboards

## API Costs

Both Pexels and Unsplash offer:
- **Free tier**: Sufficient for personal/hobby use
- **Commercial use**: No additional cost for API usage
- **Attribution**: Required in app (usually at bottom of search results)

For large-scale production apps, consider:
- Caching images locally
- Implementing request batching
- Using paid tiers for higher limits

## Support

For API-specific issues:
- Pexels Support: https://www.pexels.com/support/
- Unsplash Support: https://unsplash.com/contact

For app issues:
- Check the error message in the app
- Review the SETUP_GUIDE.md for general troubleshooting

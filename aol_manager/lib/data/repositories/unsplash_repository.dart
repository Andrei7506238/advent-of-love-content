import 'package:aol_manager/data/models/image_result_model.dart';
import 'package:aol_manager/data/repositories/image_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UnsplashRepository implements ImageRepository {
  static const String _baseUrl = 'https://api.unsplash.com';
  final String _apiKey;

  UnsplashRepository({required String apiKey}) : _apiKey = apiKey;

  @override
  Future<List<ImageResult>> searchImages(String query, int page) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/search/photos?query=$query&page=$page&per_page=20&client_id=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final results = jsonData['results'] as List;

        return results
          .map((photo) => ImageResult(
              url: photo['urls']['regular'] ?? photo['urls']['small'],
              thumbnailUrl: photo['urls']['thumb'],
              source: 'unsplash',
            ))
          .toList();
      } else {
        throw Exception('Failed to load images from Unsplash');
      }
    } catch (e) {
      throw Exception('Error searching Unsplash: $e');
    }
  }

  @override
  String getSourceName() => 'Unsplash';
}

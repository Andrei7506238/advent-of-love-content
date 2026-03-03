import 'package:aol_manager/data/models/image_result_model.dart';
import 'package:aol_manager/data/repositories/image_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PexelsRepository implements ImageRepository {
  static const String _baseUrl = 'https://api.pexels.com/v1';
  final String _apiKey;

  PexelsRepository({required String apiKey}) : _apiKey = apiKey;

  @override
  Future<List<ImageResult>> searchImages(String query, int page) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search?query=$query&page=$page&per_page=20'),
        headers: {'Authorization': _apiKey},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final photos = jsonData['photos'] as List;

        return photos
          .map((photo) => ImageResult(
              url: photo['src']['original'] ?? photo['src']['large'],
              thumbnailUrl: photo['src']['medium'],
              source: 'pexels',
            ))
          .toList();
      } else {
        throw Exception('Failed to load images from Pexels');
      }
    } catch (e) {
      throw Exception('Error searching Pexels: $e');
    }
  }

  @override
  String getSourceName() => 'Pexels';
}

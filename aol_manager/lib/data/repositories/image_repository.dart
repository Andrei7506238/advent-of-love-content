import 'package:aol_manager/data/models/image_result_model.dart';

abstract class ImageRepository {
  Future<List<ImageResult>> searchImages(String query, int page);
  String getSourceName();
}

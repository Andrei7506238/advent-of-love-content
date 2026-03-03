class ImageResult {
  final String url;
  final String thumbnailUrl;
  final String source; // 'pexels' or 'unsplash'

  ImageResult({
    required this.url,
    required this.thumbnailUrl,
    required this.source,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageResult &&
          runtimeType == other.runtimeType &&
          url == other.url &&
          source == other.source;

  @override
  int get hashCode => url.hashCode ^ source.hashCode;
}

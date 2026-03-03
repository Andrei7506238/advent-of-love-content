part of 'image_search_cubit.dart';

class ImageSearchState {
  final List<ImageResult> images;
  final bool isLoading;
  final String? error;
  final bool hasReachedMax;

  const ImageSearchState({
    required this.images,
    this.isLoading = false,
    this.error,
    this.hasReachedMax = false,
  });

  ImageSearchState copyWith({
    List<ImageResult>? images,
    bool? isLoading,
    String? error,
    bool? hasReachedMax,
  }) {
    return ImageSearchState(
      images: images ?? this.images,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

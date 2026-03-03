import 'package:bloc/bloc.dart';
import 'package:aol_manager/data/models/image_result_model.dart';
import 'package:aol_manager/data/repositories/image_repository.dart';

part 'image_search_state.dart';

class ImageSearchCubit extends Cubit<ImageSearchState> {
  final ImageRepository _imageRepository;
  int _currentPage = 1;
  String _lastQuery = '';

  ImageSearchCubit({required ImageRepository imageRepository})
      : _imageRepository = imageRepository,
        super(const ImageSearchState(images: []));

  Future<void> searchImages(String query) async {
    if (query.isEmpty) {
      emit(const ImageSearchState(images: []));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));
    _currentPage = 1;
    _lastQuery = query;

    try {
      final images = await _imageRepository.searchImages(query, _currentPage);
      emit(state.copyWith(
        images: images,
        isLoading: false,
        error: null,
        hasReachedMax: images.length < 20,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> loadMore() async {
    if (state.hasReachedMax || state.isLoading) return;

    emit(state.copyWith(isLoading: true, error: null));
    _currentPage++;

    try {
      final newImages =
          await _imageRepository.searchImages(_lastQuery, _currentPage);
      final images = [...state.images, ...newImages];
      emit(state.copyWith(
        images: images,
        isLoading: false,
        error: null,
        hasReachedMax: newImages.length < 20,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  String getSourceName() => _imageRepository.getSourceName();
}

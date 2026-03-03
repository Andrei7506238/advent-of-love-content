import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aol_manager/presentation/cubits/image_search_cubit.dart';

class ImageSearchScreen extends StatefulWidget {
  final Function(String) onImageSelected;

  const ImageSearchScreen({
    super.key,
    required this.onImageSelected,
  });

  @override
  State<ImageSearchScreen> createState() => _ImageSearchScreenState();
}

class _ImageSearchScreenState extends State<ImageSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Images'),
      ),
      body: Column(
        children: [
          // Source selector and search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search images (love, heart, couple...)',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (query) {
                    if (query.isNotEmpty) {
                      context
                          .read<ImageSearchCubit>()
                          .searchImages(query);
                    }
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.search),
                        label: const Text('Search'),
                        onPressed: _searchController.text.isEmpty
                            ? null
                            : () {
                                context
                                    .read<ImageSearchCubit>()
                                    .searchImages(_searchController.text);
                              },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Image grid
          Expanded(
            child: BlocBuilder<ImageSearchCubit, ImageSearchState>(
              builder: (context, state) {
                if (state.images.isEmpty && _searchController.text.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Search for images',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ),
                  );
                }

                if (state.isLoading && state.images.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Error: ${state.error}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollEndNotification) {
                      final before = scrollNotification.metrics.extentBefore;
                      final max = scrollNotification.metrics.maxScrollExtent;
                      if (before == max) {
                        context.read<ImageSearchCubit>().loadMore();
                      }
                    }
                    return false;
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Set a max image tile width (e.g. 180px), min 2 columns
                      const minTileWidth = 140.0;
                      final crossAxisCount = (constraints.maxWidth / minTileWidth).floor().clamp(2, 6);
                      return GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: state.images.length + (state.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.images.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final image = state.images[index];
                          return GestureDetector(
                            onTap: () {
                              widget.onImageSelected(image.url);
                              Navigator.pop(context, image.url);
                            },
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    image.thumbnailUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image),
                                      );
                                    },
                                  ),
                                ),
                                // Source overlay
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withAlpha(0),
                                          Colors.black.withAlpha(139),
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      image.source,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

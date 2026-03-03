import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aol_manager/config/api_config.dart';
import 'package:aol_manager/data/repositories/file_repository.dart';
import 'package:aol_manager/data/repositories/pexels_repository.dart';
import 'package:aol_manager/data/repositories/image_repository.dart';
import 'package:aol_manager/presentation/cubits/messages_cubit.dart';
import 'package:aol_manager/presentation/cubits/image_search_cubit.dart';
import 'package:aol_manager/presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize repositories
    final fileRepository = FileRepository();
    
    // Initialize image repository based on config
    final ImageRepository imageRepository = 
        ApiConfig.defaultImageSource == 'pexels'
            ? PexelsRepository(apiKey: ApiConfig.pexelsApiKey)
            : PexelsRepository(apiKey: ApiConfig.pexelsApiKey);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MessagesCubit(fileRepository: fileRepository),
        ),
        BlocProvider(
          create: (context) => ImageSearchCubit(imageRepository: imageRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Love Messages',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red,
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

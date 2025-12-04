import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:farmsense/models/crop_log.dart';
import 'package:farmsense/core/theme.dart';
import 'package:farmsense/repositories/crop_repository.dart';
import 'package:farmsense/views/screens/main_screen.dart'; // Import the new MainScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(CropLogAdapter());
  final cropBox = await Hive.openBox<CropLog>('cropLogs');

  // Initialize mock data if the app is empty
  final cropRepository = CropRepository(cropBox);
  await cropRepository.initMockData();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmSense',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Automatically switch based on system settings
      home: const MainScreen(), // Points to our new navigation shell
    );
  }
}
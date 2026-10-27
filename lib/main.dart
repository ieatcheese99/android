import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:android/providers/audio_player_provider.dart';
import 'package:android/providers/favorite_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final songsSnapshot = await FirebaseFirestore.instance.collection('songs').get();
    debugPrint("Berhasil terhubung ke Firestore! Jumlah lagu: ${songsSnapshot.docs.length}");
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  final favProvider = FavoriteProvider();
  await favProvider.initStorage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: favProvider),
        ChangeNotifierProvider(create: (context) => AudioPlayerProvider()),
        ChangeNotifierProvider<FavoriteProvider>.value(value: favProvider)
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F1118),
      ),
      home: const SplashScreen(),
    );
  }
}

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.windows:
        return windows;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDI5fccEcppx4zcv5E6T8tpnBX1y2KRxg0',
    appId: '1:110188574068:android:25a59e9052b93d28f7a821',
    messagingSenderId: '110188574068',
    projectId: 'music-75b93',
    storageBucket: 'music-75b93.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDI5fccEcppx4zcv5E6T8tpnBX1y2KRxg0',
    appId: '1:110188574068:android:25a59e9052b93d28f7a821',
    messagingSenderId: '110188574068',
    projectId: 'music-75b93',
    storageBucket: 'music-75b93.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDI5fccEcppx4zcv5E6T8tpnBX1y2KRxg0',
    appId: '1:110188574068:web:25a59e9052b93d28f7a821',
    messagingSenderId: '110188574068',
    projectId: 'music-75b93',
    storageBucket: 'music-75b93.firebasestorage.app',
  );
}

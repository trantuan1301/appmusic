import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDOXD90Ij94q9y1FQ3lLwetBCa0vDkZS8A',
    appId: '1:819258935348:web:393adc228f329b9225e261',
    messagingSenderId: '819258935348',
    projectId: 'musicapp-c62bf',
    authDomain: 'musicapp-c62bf.firebaseapp.com',
    storageBucket: 'musicapp-c62bf.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDvx2Oh0J9LGNJDyooqorVd2G-bPrRy8-4',
    appId: '1:819258935348:android:f5109901284748bd25e261',
    messagingSenderId: '819258935348',
    projectId: 'musicapp-c62bf',
    storageBucket: 'musicapp-c62bf.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDJYCBsNBBmojVgf26yOZk7skIOLglW6Do',
    appId: '1:819258935348:ios:9b243aba2fd4fb9c25e261',
    messagingSenderId: '819258935348',
    projectId: 'musicapp-c62bf',
    storageBucket: 'musicapp-c62bf.firebasestorage.app',
    iosBundleId: 'com.example.musicApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDJYCBsNBBmojVgf26yOZk7skIOLglW6Do',
    appId: '1:819258935348:ios:9b243aba2fd4fb9c25e261',
    messagingSenderId: '819258935348',
    projectId: 'musicapp-c62bf',
    storageBucket: 'musicapp-c62bf.firebasestorage.app',
    iosBundleId: 'com.example.musicApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDOXD90Ij94q9y1FQ3lLwetBCa0vDkZS8A',
    appId: '1:819258935348:web:4af08ead05d4c55b25e261',
    messagingSenderId: '819258935348',
    projectId: 'musicapp-c62bf',
    authDomain: 'musicapp-c62bf.firebaseapp.com',
    storageBucket: 'musicapp-c62bf.firebasestorage.app',
  );
}

// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDzILDLmYELLE-gNhUQaz2h3GiETKVNVMY',
    appId: '1:350911462545:web:743d7a2f61eb3d58bd9330',
    messagingSenderId: '350911462545',
    projectId: 'nurse25-1075b',
    authDomain: 'nurse25-1075b.firebaseapp.com',
    databaseURL: 'https://nurse25-1075b-default-rtdb.firebaseio.com',
    storageBucket: 'nurse25-1075b.firebasestorage.app',
    measurementId: 'G-83LPWW04JW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA083kv9UiDuidmpgT6sl3A5pRftIT91AU',
    appId: '1:350911462545:android:d9492334d9277eb4bd9330',
    messagingSenderId: '350911462545',
    projectId: 'nurse25-1075b',
    databaseURL: 'https://nurse25-1075b-default-rtdb.firebaseio.com',
    storageBucket: 'nurse25-1075b.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDzILDLmYELLE-gNhUQaz2h3GiETKVNVMY',
    appId: '1:350911462545:web:84fe4eadc0312b91bd9330',
    messagingSenderId: '350911462545',
    projectId: 'nurse25-1075b',
    authDomain: 'nurse25-1075b.firebaseapp.com',
    databaseURL: 'https://nurse25-1075b-default-rtdb.firebaseio.com',
    storageBucket: 'nurse25-1075b.firebasestorage.app',
    measurementId: 'G-RMB3X0EL4E',
  );
}

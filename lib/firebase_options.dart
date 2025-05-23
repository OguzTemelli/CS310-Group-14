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
    apiKey: 'AIzaSyAVQnjzFBAhk9hDeAULA82oHjG0C-4mB54',
    appId: '1:218660343420:web:f4a7de11ea2a72c6f54c74',
    messagingSenderId: '218660343420',
    projectId: 'matchmate-bugraydin',
    authDomain: 'matchmate-bugraydin.firebaseapp.com',
    databaseURL: 'https://matchmate-bugraydin-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'matchmate-bugraydin.appspot.com',
    measurementId: 'G-L1LBW6V2ZP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAVQnjzFBAhk9hDeAULA82oHjG0C-4mB54',
    appId: '1:218660343420:android:57f43bbf096c2db4f54c74',
    messagingSenderId: '218660343420',
    projectId: 'matchmate-bugraydin',
    databaseURL: 'https://matchmate-bugraydin-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'matchmate-bugraydin.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAVQnjzFBAhk9hDeAULA82oHjG0C-4mB54',
    appId: '1:218660343420:web:f4a7de11ea2a72c6f54c74',
    messagingSenderId: '218660343420',
    projectId: 'matchmate-bugraydin',
    authDomain: 'matchmate-bugraydin.firebaseapp.com',
    databaseURL: 'https://matchmate-bugraydin-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'matchmate-bugraydin.appspot.com',
    measurementId: 'G-L1LBW6V2ZP',
  );
}

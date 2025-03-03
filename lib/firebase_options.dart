// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCz2H2ktI2t6y6NRVO-aDdj2srImzf5F6o',
    appId: '1:136682921726:web:6d5420025f4b3b3c2f8faf',
    messagingSenderId: '136682921726',
    projectId: 'flutter-face-fff0d',
    authDomain: 'flutter-face-fff0d.firebaseapp.com',
    storageBucket: 'flutter-face-fff0d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBeqFzEVDS7m_TM6zC1vsC4z9KuuCSO-kg',
    appId: '1:136682921726:android:29bfc9eb1c86fc2b2f8faf',
    messagingSenderId: '136682921726',
    projectId: 'flutter-face-fff0d',
    storageBucket: 'flutter-face-fff0d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2zslmzk91sj2bl_ikOCFMByTqyAkRy8k',
    appId: '1:136682921726:ios:6ba2eddea5bcb5cb2f8faf',
    messagingSenderId: '136682921726',
    projectId: 'flutter-face-fff0d',
    storageBucket: 'flutter-face-fff0d.appspot.com',
    iosClientId: '136682921726-15lnnj6b832884bjfpq7v4994ggbcldj.apps.googleusercontent.com',
    iosBundleId: 'com.example.faceapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC2zslmzk91sj2bl_ikOCFMByTqyAkRy8k',
    appId: '1:136682921726:ios:b79414737b197c792f8faf',
    messagingSenderId: '136682921726',
    projectId: 'flutter-face-fff0d',
    storageBucket: 'flutter-face-fff0d.appspot.com',
    iosClientId: '136682921726-c38i7rt8l1ukru0sk9g43hdqqs2i9nlj.apps.googleusercontent.com',
    iosBundleId: 'com.example.faceapp.RunnerTests',
  );
}

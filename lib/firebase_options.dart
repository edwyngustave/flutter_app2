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
    apiKey: 'AIzaSyBajkyi2VP605SjJi4_wZfvMslFx9eOiL4',
    appId: '1:902871875854:web:47108f2fec18b20f82175f',
    messagingSenderId: '902871875854',
    projectId: 'ilovepizza-fd570',
    authDomain: 'ilovepizza-fd570.firebaseapp.com',
    storageBucket: 'ilovepizza-fd570.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCooRcSSqc0n9OG-goVSrTwCOq54UxXZMc',
    appId: '1:902871875854:android:f1f238240fde587a82175f',
    messagingSenderId: '902871875854',
    projectId: 'ilovepizza-fd570',
    storageBucket: 'ilovepizza-fd570.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC8A4EOaKbAgP9BU-Szp7Fu-P7KXFg2ZoQ',
    appId: '1:902871875854:ios:8bb3c1eba25d579482175f',
    messagingSenderId: '902871875854',
    projectId: 'ilovepizza-fd570',
    storageBucket: 'ilovepizza-fd570.appspot.com',
    iosBundleId: 'com.example.flutterApp2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC8A4EOaKbAgP9BU-Szp7Fu-P7KXFg2ZoQ',
    appId: '1:902871875854:ios:8bb3c1eba25d579482175f',
    messagingSenderId: '902871875854',
    projectId: 'ilovepizza-fd570',
    storageBucket: 'ilovepizza-fd570.appspot.com',
    iosBundleId: 'com.example.flutterApp2',
  );
}

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
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCEgx4sTQHgArW5n71K5BEQxi-Fl5CAEXc',
    appId: '1:796247634168:web:f379f1cb6f7ae60cc1cb0d',
    messagingSenderId: '796247634168',
    projectId: 'socialice-5c0cd',
    authDomain: 'socialice-5c0cd.firebaseapp.com',
    storageBucket: 'socialice-5c0cd.appspot.com',
    measurementId: 'G-K0SYKE8EMZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyChYZhy6NTRNLS4P4WFm3aJOhwDcCWXPzM',
    appId: '1:796247634168:android:30f84c06e52d7240c1cb0d',
    messagingSenderId: '796247634168',
    projectId: 'socialice-5c0cd',
    storageBucket: 'socialice-5c0cd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_3CrwxYg0yAXFDC5euqwmsi9_W7XrLoo',
    appId: '1:796247634168:ios:840e56fb9e49c75ec1cb0d',
    messagingSenderId: '796247634168',
    projectId: 'socialice-5c0cd',
    storageBucket: 'socialice-5c0cd.appspot.com',
    iosBundleId: 'com.example.socialIce',
  );
}
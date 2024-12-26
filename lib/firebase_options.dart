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
    apiKey: 'AIzaSyCuu1GjO1YQplVjzb2wtzcViOWvH_PPSKw',
    appId: '1:284933043927:web:016d37a1d9168a72aa6292',
    messagingSenderId: '284933043927',
    projectId: 'owepal-5da9f',
    authDomain: 'owepal-5da9f.firebaseapp.com',
    storageBucket: 'owepal-5da9f.firebasestorage.app',
    measurementId: 'G-9R90QWBDYN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDrzuhNJeS86qOyRxRoG36s8EC23ipuVVo',
    appId: '1:284933043927:android:a6e6db7c8b932de6aa6292',
    messagingSenderId: '284933043927',
    projectId: 'owepal-5da9f',
    storageBucket: 'owepal-5da9f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBA_CTPE0QnUwhNY9gvmHx7vK74qUkSLWM',
    appId: '1:284933043927:ios:c7acbb16e8abee88aa6292',
    messagingSenderId: '284933043927',
    projectId: 'owepal-5da9f',
    storageBucket: 'owepal-5da9f.firebasestorage.app',
    iosBundleId: 'com.example.owePal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBA_CTPE0QnUwhNY9gvmHx7vK74qUkSLWM',
    appId: '1:284933043927:ios:c7acbb16e8abee88aa6292',
    messagingSenderId: '284933043927',
    projectId: 'owepal-5da9f',
    storageBucket: 'owepal-5da9f.firebasestorage.app',
    iosBundleId: 'com.example.owePal',
  );
}

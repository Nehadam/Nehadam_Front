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
    apiKey: 'AIzaSyA0Ar94rJWALS80OoV45pGQ_2VpkXHhAM8',
    appId: '1:516065174839:web:80be7f7a04af90517aa6b2',
    messagingSenderId: '516065174839',
    projectId: 'nehadam-b5c09',
    authDomain: 'nehadam-b5c09.firebaseapp.com',
    databaseURL: 'https://nehadam-b5c09-default-rtdb.firebaseio.com',
    storageBucket: 'nehadam-b5c09.appspot.com',
    measurementId: 'G-FJLK5C79Q0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDBpr8m1e2juDOOkJjfnehkEH5QTETeIDo',
    appId: '1:516065174839:android:a2b713f40dbb182a7aa6b2',
    messagingSenderId: '516065174839',
    projectId: 'nehadam-b5c09',
    databaseURL: 'https://nehadam-b5c09-default-rtdb.firebaseio.com',
    storageBucket: 'nehadam-b5c09.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD1OHNH7uM7LQ3VDYKzOS8b4ZrHDFTPE_4',
    appId: '1:516065174839:ios:b302fc41691d9a1b7aa6b2',
    messagingSenderId: '516065174839',
    projectId: 'nehadam-b5c09',
    databaseURL: 'https://nehadam-b5c09-default-rtdb.firebaseio.com',
    storageBucket: 'nehadam-b5c09.appspot.com',
    iosClientId: '516065174839-bddu46rraojj08l9hphgdlie389jbven.apps.googleusercontent.com',
    iosBundleId: 'com.example.Nehadam',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD1OHNH7uM7LQ3VDYKzOS8b4ZrHDFTPE_4',
    appId: '1:516065174839:ios:b302fc41691d9a1b7aa6b2',
    messagingSenderId: '516065174839',
    projectId: 'nehadam-b5c09',
    databaseURL: 'https://nehadam-b5c09-default-rtdb.firebaseio.com',
    storageBucket: 'nehadam-b5c09.appspot.com',
    iosClientId: '516065174839-bddu46rraojj08l9hphgdlie389jbven.apps.googleusercontent.com',
    iosBundleId: 'com.example.Nehadam',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA0Ar94rJWALS80OoV45pGQ_2VpkXHhAM8',
    appId: '1:516065174839:web:1795afb150dbf2797aa6b2',
    messagingSenderId: '516065174839',
    projectId: 'nehadam-b5c09',
    authDomain: 'nehadam-b5c09.firebaseapp.com',
    databaseURL: 'https://nehadam-b5c09-default-rtdb.firebaseio.com',
    storageBucket: 'nehadam-b5c09.appspot.com',
    measurementId: 'G-8K9YSE7BSW',
  );

}
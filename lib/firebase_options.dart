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
    apiKey: 'AIzaSyDb51ajEmq-sH3ocG1yCbrfZBDlpdXN78s',
    appId: '1:82095359622:web:d0ff1b43dc754bbe72b307',
    messagingSenderId: '82095359622',
    projectId: 'reddit-clone-3741d',
    authDomain: 'reddit-clone-3741d.firebaseapp.com',
    storageBucket: 'reddit-clone-3741d.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAY7U7Z4V1XwJhW0Qig7RjDedmtJ-ZKaTk',
    appId: '1:82095359622:android:db7cf650d01b6ab172b307',
    messagingSenderId: '82095359622',
    projectId: 'reddit-clone-3741d',
    storageBucket: 'reddit-clone-3741d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDkIIC5QQrk4YURJV6Oz_7HKomikrOJf8w',
    appId: '1:82095359622:ios:4ab7db8e5fdaeea772b307',
    messagingSenderId: '82095359622',
    projectId: 'reddit-clone-3741d',
    storageBucket: 'reddit-clone-3741d.appspot.com',
    iosClientId: '82095359622-07u946mbec7vp7l0ua4s207mrpf1qsmf.apps.googleusercontent.com',
    iosBundleId: 'com.example.redditClone',
  );
}

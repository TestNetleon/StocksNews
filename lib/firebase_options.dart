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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA26KdOgpIBTIVuNfZwRoixNsfPnMKT2rE',
    appId: '1:661986825229:android:ce1c460925d54b155bb144',
    messagingSenderId: '661986825229',
    projectId: 'stocksnews-ef556',
    storageBucket: 'stocksnews-ef556.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAT0DHf6hY6rEHqXS6eQJ_-8Fqa8pLnMio',
    appId: '1:661986825229:ios:2958225927da6ea85bb144',
    messagingSenderId: '661986825229',
    projectId: 'stocksnews-ef556',
    storageBucket: 'stocksnews-ef556.firebasestorage.app',
    androidClientId:
        '661986825229-0de23kv34v919suf1ticnuth3f8rn9i3.apps.googleusercontent.com',
    iosClientId:
        '661986825229-jrjm8ffa2meg5ld2drpmg9pgsg4mh6nq.apps.googleusercontent.com',
    iosBundleId: 'app.stocks.news',
  );
}

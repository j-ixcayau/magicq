import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

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
    apiKey: 'AIzaSyBaizEMvSxEIEFErhXXlFA_urGLCzP4hbk',
    appId: '1:848436920318:web:bec7a42f033a6613820aaf',
    messagingSenderId: '848436920318',
    projectId: 'magic-sc',
    authDomain: 'magic-sc.firebaseapp.com',
    storageBucket: 'magic-sc.appspot.com',
    measurementId: 'G-WD8KCD5FX2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyASBxzzZ7fzM5EiS8Bfl-RhvWs3-f95M5M',
    appId: '1:848436920318:android:5905355119a16b8d820aaf',
    messagingSenderId: '848436920318',
    projectId: 'magic-sc',
    storageBucket: 'magic-sc.appspot.com',
  );
}

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Get these values from your Firebase Console
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCCN-qbHkfS97AuoQFO1xDxMXmjUbit-mg',
    appId: '1:147129905366:android:c6264dd457ab9a47cc1977',
    messagingSenderId: '147129905366',
    projectId: 'bloomhealth-f6f03',
    storageBucket: 'bloomhealth-f6f03.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:YOUR_PROJECT_NUMBER:ios:YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
    iosBundleId: 'com.manrtitech.medTracker',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: '1:YOUR_PROJECT_NUMBER:web:YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'your-project-id',
    authDomain: 'your-project-id.firebaseapp.com',
    storageBucket: 'your-project-id.appspot.com',
    measurementId: 'YOUR_MEASUREMENT_ID',
  );
}
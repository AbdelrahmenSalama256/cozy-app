

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;











//! DefaultFirebaseOptions
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
    apiKey: 'AIzaSyCDgWNQKI3h0ZASErU55kusxNYjb42FQ5E',
    appId: '1:142099948756:android:9ad3c133241c6c93688741',
    messagingSenderId: '142099948756',
    projectId: 'cozy-home-1ebd3',
    storageBucket: 'cozy-home-1ebd3.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDWd2eIr9JvoAT2EmchwsltgOZgQ2dqWis',
    appId: '1:142099948756:ios:745f0e0b58d77e80688741',
    messagingSenderId: '142099948756',
    projectId: 'cozy-home-1ebd3',
    storageBucket: 'cozy-home-1ebd3.firebasestorage.app',
    iosBundleId: 'com.cangrow.cozy',
  );
}

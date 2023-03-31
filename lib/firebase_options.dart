import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyB-YcZjPgs7A-pmxo0jKFEAInkogI2HY4U',
    appId: '1:1056719233812:web:9b39cd15dfdfe6ee125801',
    messagingSenderId: '1056719233812',
    projectId: 'fluttervideocall-3f317',
    authDomain: 'fluttervideocall-3f317.firebaseapp.com',
    storageBucket: 'fluttervideocall-3f317.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBnGbnH52fxj-CCs_RMazI3N_qEDXS_oZE',
    appId: '1:1056719233812:android:bc4e8d9040523c30125801',
    messagingSenderId: '1056719233812',
    projectId: 'fluttervideocall-3f317',
    storageBucket: 'fluttervideocall-3f317.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBCDvExiCfjKuUPCRmROSOaH7HxI8elNOg',
    appId: '1:1056719233812:ios:06f0cd221bb9f396125801',
    messagingSenderId: '1056719233812',
    projectId: 'fluttervideocall-3f317',
    storageBucket: 'fluttervideocall-3f317.appspot.com',
    iosClientId: '1056719233812-ovhi566chc4g28dq0qs4om5g7dau6jke.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterVideoCall',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBCDvExiCfjKuUPCRmROSOaH7HxI8elNOg',
    appId: '1:1056719233812:ios:06f0cd221bb9f396125801',
    messagingSenderId: '1056719233812',
    projectId: 'fluttervideocall-3f317',
    storageBucket: 'fluttervideocall-3f317.appspot.com',
    iosClientId: '1056719233812-ovhi566chc4g28dq0qs4om5g7dau6jke.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterVideoCall',
  );
}

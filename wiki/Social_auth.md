# Setting up and maintaining login providers

This page documents the implementation and maintenance of the various sign-in methods using third-party providers found in the app.

- [FlutterFire social auth documentation](https://firebase.flutter.dev/docs/auth/social)
- [App signing for Android apps](https://developer.android.com/studio/publish/app-signing#generate-key)

## Known issues

- Social sign-ins do not work when using the Firebase emulator suite. The production back-ends must be used.

## Facebook sign-in

### Android

- The FlutterFire documentation is incomplete, follow the [`flutter_facebook_auth` package docs](https://facebook.meedu.app/docs/4.x.x/intro)
- The project is currently tied to the Facebook developer account of Darrick Lau.
- Any new developer should add their development key hash to the Facebook developer portal. Contact the repo admin for further action.
- Releases are signed by Google Play. The release key hash can be retrieved from the Google Play Console.

## Google sign-in

Google works mostly out of the box, but requires the development and release key SHA-1 hashes to be added to the Firebase console under the android app.

## Email link sign-in

TBD

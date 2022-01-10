# Flutter Android Workflows

This guide attempts to document the processes, challenges and gotchas encountered in the development and release of a Flutter project on the Google Play Store.

## [Gotcha] Creating the app with the right name

As it turns out, renaming the bundle identifier is horribly troublesome after the first-time Flutter setup.

## Adding Firebase to a Flutter Android app

Start by following the [FlutterFire](https://firebase.flutter.dev/docs/overview) documentation. Manual configuration is no longer necessary due to the addition of Dart-only configuration, but is documented below:

### Manual configuration

Previously, Firebase required developers to maintain a `google-services.json` file in the `android/app` directory.

1. Log in to the [Firebase console](https://console.firebase.google.com/) and select / create the current project.
2. Firebase will prompt you to perform steps to setup the SDK. The result is a few config lines added to both project and app-level `build.gradle` files.

## Maintaining keystores

Google Play Store requires all apps to be [signed before publishing](https://developer.android.com/studio/publish/app-signing#generate-key).

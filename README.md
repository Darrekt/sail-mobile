# Sail

An app that makes being apart a little less painful for couples separated by distance.

## Development pre-requisites

Ensure that the following are installed on your system:

- A working install of Flutter
- GPG, for decryption of secrets ([Recommended install with Homebrew](https://formulae.brew.sh/formula/gnupg))
- Firebase CLI and emulator suite

## Design

This app uses [Bloc](https://bloclibrary.dev/#/) for state management.

## Contributing

### Agile board

Our Trello board can be found [here](https://trello.com/b/1mG8PKVQ/spark).

### Running tests

Before you run tests, you need to autogenerate all the mock classes by running

```dart
dart run build_runner build
```

After which, you should be able to run `flutter test`.

## Links for later

- [Getting the Android release key has using Google Play Signing](https://stackoverflow.com/questions/44355452/google-play-app-signing-key-hash/44448437#44448437)

## Setting up Flutter

- [Android SDK flutter doctor issues](https://stackoverflow.com/questions/60475481/flutter-doctor-error-android-sdkmanager-tool-not-found-windows)

### Responsiveness and font styling

- [Theming in Flutter](https://flutter.dev/docs/cookbook/design/themes)
- [Flutter: Using custom fonts](https://flutter.dev/docs/cookbook/design/fonts)
- [Google Fonts library](https://pub.dev/packages/google_fonts)
- [Google Fonts preview tool](https://fonts.google.com/)

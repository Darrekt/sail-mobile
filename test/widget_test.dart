// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:spark/repositories/repositories_barrel.dart';
import 'widget_test.mocks.dart';

import 'package:spark/main.dart';

@GenerateMocks([FirebaseAuthRepository, FirebasePicturesRepository])
void main() async {
  testWidgets('App should be startable', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final AuthRepository authRepository = MockFirebaseAuthRepository();
    final PicturesRepository picturesRepository =
        MockFirebasePicturesRepository();
    await tester.pumpWidget(SparkApp(
      authRepository: authRepository,
      picturesRepository: picturesRepository,
    ));
  });
}

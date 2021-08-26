import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart' as mockito;
import 'auth_bloc_test.mocks.dart';

import 'package:spark/blocs/bloc_barrel.dart';
import 'package:spark/models/SparkUser.dart';
import 'package:spark/repositories/repositories_barrel.dart';

@GenerateMocks([FirebaseAuthRepository])
void main() {
  group('Auth Bloc initialisation tests', () {
    late MockFirebaseAuthRepository mockRepo;
    late SparkUser testUser, testPartner;
    late AuthBloc auth;

    setUpAll(() {
      testUser = SparkUser.fromScratch(id: "Darrick");
      testPartner = SparkUser.fromScratch(id: "Maria");
      mockRepo = MockFirebaseAuthRepository();
      auth = AuthBloc(auth: mockRepo);

      mockito
          .when(mockRepo.getUser())
          .thenAnswer((_) => Stream.fromIterable([testUser]));

      mockito
          .when(mockRepo.getPartner(testUser))
          .thenAnswer((_) => Stream.fromIterable([testPartner]));
    });

    test('Initial state should be AppLoading()', () {
      expect(auth.state, AppLoading());
    });

    blocTest(
      'Emits [] when nothing is added',
      build: () => auth,
      expect: () => [],
    );

    blocTest(
      'Emits authenticated and paired states after startup',
      build: () => auth,
      act: (AuthBloc bloc) => bloc.add(AppStarted()),
      expect: () => [Authenticated(testUser), Paired(testUser, testPartner)],
    );
  });
}

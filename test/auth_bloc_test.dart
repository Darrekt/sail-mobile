import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart' as mockito;
import 'auth_bloc_test.mocks.dart';

import 'package:sail/blocs/bloc_barrel.dart';
import 'package:sail/models/SparkUser.dart';
import 'package:sail/repositories/repositories_barrel.dart';

@GenerateMocks([FirebaseAuthRepository])
void main() {
  final SparkUser testUser = SparkUser.fromScratch(id: "Darrick");
  final SparkUser testPartner = SparkUser.fromScratch(id: "Maria");
  group('Auth Bloc initialisation tests', () {
    late MockFirebaseAuthRepository mockRepo;
    late AuthBloc auth;

    setUp(() {
      mockRepo = MockFirebaseAuthRepository();
      auth = AuthBloc(auth: mockRepo);
      mockito
          .when(mockRepo.getUser())
          .thenAnswer((_) => Stream.fromIterable([testUser]));

      mockito
          .when(mockRepo.getPartner(testUser))
          .thenAnswer((_) => Stream.fromIterable([SparkUser.empty]));
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
      'Emits authenticated state without pairing after startup',
      build: () => auth,
      setUp: () {},
      act: (AuthBloc bloc) => bloc.add(AppStarted()),
      expect: () => [Authenticated(testUser)],
    );

    blocTest(
      'Emits authenticated and paired states after startup',
      build: () => auth,
      setUp: () {
        mockito
            .when(mockRepo.getUser())
            .thenAnswer((_) => Stream.fromIterable([testUser]));

        mockito
            .when(mockRepo.getPartner(testUser))
            .thenAnswer((_) => Stream.fromIterable([testPartner]));
      },
      act: (AuthBloc bloc) => bloc.add(AppStarted()),
      expect: () => [Authenticated(testUser), Paired(testUser, testPartner)],
    );
  });

  group('Auth Bloc logout checks', () {
    late MockFirebaseAuthRepository mockRepo;
    late AuthBloc auth;
    late StreamController<SparkUser> userStreamController;

    setUp(() {
      mockRepo = MockFirebaseAuthRepository();
      auth = AuthBloc(auth: mockRepo);
      userStreamController = StreamController();
    });

    tearDown(() => userStreamController.close());

    blocTest(
      'Emits Unauthenticated from paired state on logout',
      build: () => auth,
      setUp: () {
        mockito
            .when(mockRepo.getUser())
            .thenAnswer((_) => userStreamController.stream);

        mockito
            .when(mockRepo.getPartner(testUser))
            .thenAnswer((_) => Stream.fromIterable([testPartner]));

        mockito
            .when(mockRepo.logout())
            .thenAnswer((_) async => userStreamController.add(SparkUser.empty));
      },
      act: (AuthBloc bloc) async {
        bloc.add(AppStarted());
        userStreamController.add(testUser);
        await Future.delayed(Duration(microseconds: 10));
        bloc.add(Logout());
      },
      expect: () => [
        Authenticated(testUser),
        Paired(testUser, testPartner),
        Unauthenticated(),
      ],
    );
  });

  group('Auth Bloc logout checks', () {
    late MockFirebaseAuthRepository mockRepo;
    late AuthBloc auth;
    late StreamController<SparkUser> userStreamController;

    setUp(() {
      mockRepo = MockFirebaseAuthRepository();
      auth = AuthBloc(auth: mockRepo);
      userStreamController = StreamController();
    });

    tearDown(() => userStreamController.close());

    blocTest(
      'Emits Unauthenticated from authenticated state on logout',
      build: () => auth,
      setUp: () {
        mockito
            .when(mockRepo.getUser())
            .thenAnswer((_) => userStreamController.stream);

        mockito
            .when(mockRepo.getPartner(testUser))
            .thenAnswer((_) => Stream.fromIterable([SparkUser.empty]));

        mockito
            .when(mockRepo.logout())
            .thenAnswer((_) async => userStreamController.add(SparkUser.empty));
      },
      act: (AuthBloc bloc) async {
        bloc.add(AppStarted());
        userStreamController.add(testUser);
        bloc.add(Logout());
        bloc.add(Logout());
      },
      expect: () => [
        Authenticated(testUser),
        Unauthenticated(),
      ],
    );

    blocTest(
      'Emits Unauthenticated from Paired state on logout',
      build: () => auth,
      setUp: () {
        mockito
            .when(mockRepo.getUser())
            .thenAnswer((_) => userStreamController.stream);

        mockito
            .when(mockRepo.getPartner(testUser))
            .thenAnswer((_) => Stream.fromIterable([testPartner]));

        mockito
            .when(mockRepo.logout())
            .thenAnswer((_) async => userStreamController.add(SparkUser.empty));
      },
      act: (AuthBloc bloc) async {
        bloc.add(AppStarted());
        userStreamController.add(testUser);
        await Future.delayed(Duration(microseconds: 10));
        bloc.add(Logout());
      },
      expect: () => [
        Authenticated(testUser),
        Paired(testUser, testPartner),
        Unauthenticated(),
      ],
    );
  });

  group('Auth Bloc action checks', () {
    late MockFirebaseAuthRepository mockRepo;
    late AuthBloc auth;
    late StreamController<SparkUser> userStreamController;

    setUp(() {
      mockRepo = MockFirebaseAuthRepository();
      auth = AuthBloc(auth: mockRepo);
      userStreamController = StreamController();
    });

    tearDown(() => userStreamController.close());

    blocTest(
      'Updates user state when profile picture is added',
      build: () => auth,
      setUp: () {
        mockito
            .when(mockRepo.getUser())
            .thenAnswer((_) => userStreamController.stream);

        mockito
            .when(mockRepo.getPartner(testUser))
            .thenAnswer((_) => Stream.fromIterable([testPartner]));
      },
      act: (AuthBloc bloc) {
        bloc.add(AppStarted());
        userStreamController.add(testUser);
      },
      expect: () => [
        Authenticated(testUser),
        Paired(testUser, testPartner),
      ],
    );
  });
}

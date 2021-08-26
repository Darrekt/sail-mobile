import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:spark/blocs/bloc_barrel.dart';
import 'package:spark/models/SparkUser.dart';
import 'package:spark/repositories/repositories_barrel.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'auth_bloc_test.mocks.dart';

final SparkUser testUser = SparkUser.fromScratch(id: "Test");

// class MockAuthRepository implements AuthRepository {
//   Future<bool> isAuthenticated() async {
//     return true;
//   }

//   Stream<SparkUser> getUser() async* {
//     // Yield an list of users over 1s
//   }

//   // TODO: Implement
//   Stream<SparkUser> getPartner(SparkUser user) async* {
//     // bool loggedIn = await isAuthenticated();
//     // if (loggedIn) {
//     //   _firestore
//     //       .collection('users')
//     //       .doc(_firebaseAuth.currentUser!.uid)
//     //       .snapshots()
//     //       .listen((event) async* {
//     //     yield event.data()?['partner'];
//     //   });
//     // } else
//     //   yield null;
//     throw NotImplementedException();
//   }

//   Future<void> signUpEmail(String email, String password) async {
//     return;
//   }

//   Future<void> authenticateEmail(String email, String password) async {
//     return;
//   }

//   Future<void> authenticateEmailLink(String email) async {
//     return;
//   }

//   Future<void> authenticateApple() async {
//     return;
//   }

//   Future<UserCredential> authenticateFacebook() async {}

//   Future<UserCredential> authenticateGoogle() async {}

//   Future<void> logout() async {
//     return;
//   }

//   Future<void> linkEmail(String email, String password) async {
//     return;
//   }
// }

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

// class AuthEventFake extends Fake implements AuthEvent {}
// class AuthStateFake extends Fake implements AuthState {}

@GenerateMocks([FirebaseAuthRepository])
void main() {
  MockFirebaseAuthRepository mockRepo = MockFirebaseAuthRepository();
  group('Auth Bloc tests', () {
    blocTest(
      'emits [] when nothing is added',
      build: () => AuthBloc(auth: mockRepo),
      expect: () => [],
    );

    // TODO: Work out the behaviour of mockRepo so that this test works.
    // blocTest(
    //   'Emits loading state when app is started',
    //   build: () => AuthBloc(auth: mockRepo),
    //   act: (AuthBloc bloc) => bloc.add(AppStarted()),
    //   expect: () => [AppLoading()],
    // );
  });
}

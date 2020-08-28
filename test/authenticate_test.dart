import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:mockito/mockito.dart';
import 'package:scheduleapp/data/user_repository.dart';
import 'package:scheduleapp/presentation/page/user.dart';

// class MockFirebaseAuth extends Mock implements FirebaseAuth{}
// class MockFirebaseUser extends Mock implements FirebaseUser{}
// class MockAuthResult extends Mock implements AuthResult{}
abstract class BaseAuthenticationProvider{
  Future<FirebaseUser> signInWithGoogle();
  Future<void> signOutUser();
  Future<FirebaseUser> getCurrentUser();
  Future<bool> isLoggedIn();
}

abstract class BaseUserDataProvider{
  Future<User> saveDetailsFromGoogleAuth(FirebaseUser user);
  Future<User> saveProfileDetails(String uid, String profileImageUrl, int age, String username);
  Future<bool> isProfileComplete(String uid);
}

// class UserDataProvider extends BaseUserDataProvider {
// final fireStoreDb = Firestore.instance;

// @override
// Future<User> saveDetailsFromGoogleAuth(FirebaseUser user) async {
//   DocumentReference ref = fireStoreDb
//       .collection(Paths.usersPath)
//       .document(user.uid); //reference of the user's document node in database/users. This node is created using uid
//   final bool userExists = await ref.snapshots().isEmpty; // check if user exists or not
//   var data = {
//     //add details received from google auth
//     'uid': user.uid,
//     'email': user.email,
//     'name': user.displayName,
//   };
//   if (!userExists) { // if user entry exists then we would not want to override the photo url with the one received from googel auth
//     data['photoUrl'] = user.photoUrl;
//   }
//   ref.setData(data, merge: true); // set the data
//   final DocumentSnapshot currentDocument = await ref.get(); // get updated data reference
//   return User.fromFirestore(currentDocument); // create a user object and return
// }

// @override
// Future<User> saveProfileDetails(
//     String uid, String profileImageUrl, int age, String username) async {
//   DocumentReference ref =
//   fireStoreDb.collection(Paths.usersPath).document(uid); //reference of the user's document node in database/users. This node is created using uid
//   var data = {
//     'photoUrl': profileImageUrl,
//     'age': age,
//     'username': username,
//   };
//   ref.setData(data, merge: true); // set the photourl, age and username
//   final DocumentSnapshot currentDocument = await ref.get(); // get updated data back from firestore
//   return User.fromFirestore(currentDocument); // create a user object and return it
// }

// @override
// Future<bool> isProfileComplete(String uid) async {
// //   DocumentReference ref =
// //   fireStoreDb.collection(Paths.usersPath).document(uid);  // get reference to the user/ uid node
// //   final DocumentSnapshot currentDocument = await ref.get();
// //   return (currentDocument.exists&&
// //       currentDocument.data.containsKey('username') &&
// //       currentDocument.data.containsKey('age')); // check if it exists, if yes then check if username and age field are there or not. If not then profile incomplete else complete
// // }
// }

class AuthenticationProvider extends BaseAuthenticationProvider{
      FirebaseAuth firebaseAuth =  FirebaseAuth.instance;
      GoogleSignIn googleSignIn =  GoogleSignIn();
       AuthenticationProvider({ this.firebaseAuth, this.googleSignIn});

      Future<FirebaseUser> signInWithGoogle() async {
        final GoogleSignInAccount account =
        await googleSignIn.signIn(); //show the goggle login prompt
        final GoogleSignInAuthentication authentication =
        await account.authentication; //get the authentication object
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          //retreive the authentication credentials
            idToken: authentication.idToken,
            accessToken: authentication.accessToken);
        await firebaseAuth.signInWithCredential(
            credential); //sign in to firebase using the generated credentials
        return firebaseAuth.currentUser(); //return the firebase user created
      }

      @override
      Future<void> signOutUser() async {
        return Future.wait([firebaseAuth.signOut(), googleSignIn.signOut()]); // terminate the session
      }

      @override
      Future<FirebaseUser> getCurrentUser() async {
        return await firebaseAuth.currentUser(); //retrieve the current user
      }

      @override
      Future<bool> isLoggedIn() async {
        final user = await firebaseAuth.currentUser(); //check if user is logged in or not
        return user != null;
      }
}


// void main() {
//   MockFirebaseAuth _auth = MockFirebaseAuth();
//   BehaviorSubject <MockFirebaseUser> _user =  BehaviorSubject<MockFirebaseUser>();
//   when(_auth.onAuthStateChanged).thenAnswer((_){
//     return _user;
//   });
//   UserRepository _repo = UserRepository.instance(auth: _auth);
//   group('user repository test', (){
//     when(_auth.signInWithEmailAndPassword(email: "email",password: "password")).thenAnswer((_)async{
//       _user.add(MockFirebaseUser());
//       return MockAuthResult();
//     });
//     when(_auth.signInWithEmailAndPassword(email: "mail",password: "pass")).thenThrow((){
//       return null;
//     });
//     test("sign in with email and password", () async {
//       bool signedIn = await _repo.signIn("email", "password");
//       expect(signedIn, true);
//       expect(_repo.status, Status.Authenticated);
//     });
//
//     test("sing in fails with incorrect email and password",() async {
//       bool signedIn = await _repo.signIn("mail", "pass");
//       expect(signedIn, false);
//       expect(_repo.status, Status.Unauthenticated);
//     });
//
//     test('sign out', ()async{
//       await _repo.signOut();
//       expect(_repo.status, Status.Unauthenticated);
//     });
//   });
// }

class FirebaseUserMock extends Mock implements FirebaseUser{
  @override
  String get displayName => 'Tran Hoang';
  @override
  String get uid => 'uid';
  @override
  String get email => 'nghngtran68@gmail.com';
  @override
  String get photoUrl => 'http://www.adityag.me';
}

class FirebaseAuthMock extends Mock implements FirebaseAuth{}
class GoogleSignInMock extends Mock implements GoogleSignIn{}
class GoogleSignInAccountMock extends Mock implements GoogleSignInAccount{}
class GoogleSignInAuthenticationMock extends Mock implements GoogleSignInAuthentication{}
void main(){
  FirebaseAuthMock firebaseAuth = FirebaseAuthMock();
  GoogleSignInMock googleSignIn = GoogleSignInMock();

  AuthenticationProvider authenticationProvider = AuthenticationProvider(
      firebaseAuth: firebaseAuth, googleSignIn: googleSignIn);

  //Mock rest of the objects needed to replicate the AuthenticationProvider functions
  final GoogleSignInAccountMock googleSignInAccount =
  GoogleSignInAccountMock();
  final GoogleSignInAuthenticationMock googleSignInAuthentication =
  GoogleSignInAuthenticationMock();
  final FirebaseUserMock firebaseUser = FirebaseUserMock();

  test('signInWithGoogle returns a Firebase user', () async {
    //mock the method calls
    when(googleSignIn.signIn()).thenAnswer(
            (_) => Future<GoogleSignInAccountMock>.value(googleSignInAccount));
    when(googleSignInAccount.authentication).thenAnswer((_) =>
    Future<GoogleSignInAuthenticationMock>.value(
        googleSignInAuthentication));
    when(firebaseAuth.currentUser())
        .thenAnswer((_) => Future<FirebaseUserMock>.value(firebaseUser));
    expect(await authenticationProvider.signInWithGoogle(), firebaseUser);
    verify(googleSignIn.signIn()).called(1);
    verify(googleSignInAccount.authentication).called(1);
  });

  test('getCurrentUser returns current user', () async {
    when(firebaseAuth.currentUser())
        .thenAnswer((_) => Future<FirebaseUserMock>.value(firebaseUser));
    expect(await authenticationProvider.getCurrentUser(), firebaseUser);
    print(firebaseAuth.currentUser());
    expect(await firebaseAuth.currentUser(), 'nghngtran68@gmail.com');
  });

  test('isLoggedIn return true only when FirebaseAuth has a user', () async {
    when(firebaseAuth.currentUser())
        .thenAnswer((_) => Future<FirebaseUserMock>.value(firebaseUser));
    expect(await authenticationProvider.isLoggedIn(), true);
    when(firebaseAuth.currentUser())
        .thenAnswer((_) => Future<FirebaseUserMock>.value(null));
    expect(await authenticationProvider.isLoggedIn(), false);
  });
}
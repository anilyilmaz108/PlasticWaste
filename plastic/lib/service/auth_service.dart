import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService extends ChangeNotifier{
  final _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInAnonymously() async {
    try {
      final UserCredential userCredentials =
      await _firebaseAuth.signInAnonymously();
      return userCredentials.user;
    } catch (_) {
      rethrow;
    }
  }

  Future<User?> CreateUserWithEmailAndPassword(String email, String password, String userName)async{

    UserCredential userCredential;
    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password, );
      userCredential.user?.updateDisplayName(userName);
      return userCredential.user;

    } on FirebaseAuthException catch(e){
      print(e.code);
      print(e.message);
      rethrow;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password)async{
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<void> sendPasswordResetEmail(String email)async{
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if(googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
      await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    }
    else{
      return null;
    }
  }

  Future<User?>SignOut()async{
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();

  }

  Stream<User?>authStatus(){
    return _firebaseAuth.authStateChanges();
  }

  Future<User?>deleteAccount()async{
    try {
      await FirebaseAuth.instance.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('The user must reauthenticate before this operation can be executed.');
      }
    }
  }

  Future<User?>Reauthenticating(String email, String password)async{
    // Prompt the user to enter their email and password


// Create a credential
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

// Reauthenticate
    await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(credential);
  }

}

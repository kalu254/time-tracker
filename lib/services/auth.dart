import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  User get currentUser;

  Future<User> signInAnonymously();

  Future<void> signOut();

  Stream<User> authStateChanges();

  Future<User> signInWithGoogle();

  Future<User> signInWithFacebook();

  Future<User> signInWithEmailAndPassword(String email, String password);

  Future<User> createAccountWithEmailAndPassword(String email, String password);
}

class Auth implements AuthBase {
  final _FirebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User> authStateChanges() => _FirebaseAuth.authStateChanges();

  @override
  User get currentUser => FirebaseAuth.instance.currentUser;

  @override
  Future<User> signInAnonymously() async {
    final userCredential = await _FirebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _FirebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
            code: 'MISSING_GOOGLE_ID_TOKEN', message: 'Missing Google Token');
      }
    } else {
      throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookgin = FacebookLogin();
    await facebookgin.logOut();
    await _FirebaseAuth.signOut();
  }

  @override
  Future<User> signInWithFacebook() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (response.status) {
      case FacebookLoginStatus.Success:
        final accessToken = response.accessToken;
        final userCredential = await _FirebaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(accessToken.token),
        );
        return userCredential.user;
      case FacebookLoginStatus.Cancel:
        throw FirebaseAuthException(
            code: "ERROR_ABORTED_BY_USER", message: "Sign in aborted by user");
      case FacebookLoginStatus.Error:
        throw FirebaseAuthException(
            code: "ERROR_FACEBOOK_LOGIN_FAILED", message: response.error.developerMessage);
        default:
          throw UnimplementedError();
    }
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async{
    final userCredential = await _FirebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password)
    );

    return userCredential.user;
  }

  @override
  Future<User> createAccountWithEmailAndPassword(String email, String password) async{
   final userCredential = await _FirebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
   return userCredential.user;
  }


}

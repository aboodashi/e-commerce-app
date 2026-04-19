import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  Stream<User?> get user => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'An unknown error occurred during sign up.');
    }
  }

  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'An unknown error occurred during sign in.');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw Exception(
        e.message ??
            'An unknown error occurred while sending email verification.',
      );
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(
        e.message ?? 'An unknown error occurred while resetting password.',
      );
    }
  }

  Future<UserCredential?> signInAnonymously() async {
    try {
      return await _firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw Exception(
        e.message ?? 'An unknown error occurred during anonymous sign in.',
      );
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // The user canceled the sign-in
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('An unknown error occurred during Google sign in: $e');
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return result.user!;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'ERROR_SIGN_IN_FAILED',
        message: 'Failed to sign in with email and password',
      );
    }
  }
}

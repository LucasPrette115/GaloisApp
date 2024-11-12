import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw FirebaseAuthException(
            code: 'weak-password',
            message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw FirebaseAuthException(
            code: 'email-already-in-use',
            message: 'The account already exists for that email.');
      } else {
        throw FirebaseAuthException(
            code: e.code, message: e.message ?? "Unknown error occurred.");
      }
    } catch (e) {
      throw Exception("An unknown error occurred.");
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<String> createAccountWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<String> loginAccountWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Login Successfully";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return "mail send";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<bool> isLogIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}

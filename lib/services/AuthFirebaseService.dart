import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';

class AuthFirebaseService {
  // get firebase instance
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final firestoreService = Firestoreservice();

  //signIn
  Future<UserCredential> signIn(String email, String password) async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      return user;
    } on FirebaseAuthException catch (err) {
      print(err);
      throw Exception(err);
    }
  }

  //signUp

  Future<UserCredential> signUp(
      String email, String password, String username) async {
    print("check");
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(user);
      firestoreService.addUserToDatabase(user.user!.uid, email, username);

      return user;
    } on FirebaseAuthException catch (err) {
      print(err);
      throw Exception(err);
    }
  }

  //logout

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}

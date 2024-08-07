import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithEmailPassword(
    String email,
    String password,
    String firstName,
    String lastName,
    String bio,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'firstName': firstName, // Yeni eklenen
        'lastName': lastName, // Yeni eklenen
        'bio': bio,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception('Error during user sign-up');
    }
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }

  String? getCurrentUserEmail() {
    User? user = _auth.currentUser;
    return user?.email;
  }

  String? getCurrentUserId() {
    User? user = _auth.currentUser;
    return user?.uid;
  }
}

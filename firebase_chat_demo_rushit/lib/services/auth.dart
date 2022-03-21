import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Condition ? True : False
  UserModel _userFromFirebaseUser(User user){
    return user != null
        ? UserModel(userId: user.uid)
        : null!;
  }

  Future signInWithEmailAndPassword(String email, String pass) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      User firebaseUser = result.user!;
      return _userFromFirebaseUser(firebaseUser);
    } catch(e) {
      print('Error : $e');
    }
  }

  Future signUpWithEmailAndPassword(String email, String pass) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      User firebaseUser = result.user!;
      return _userFromFirebaseUser(firebaseUser);
    } catch(e) {
      print('Error : $e');
    }
  }

  Future resetPassword(String email) async {
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    } catch(e) {
      print('Error : $e');
    }
  }

  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e) {
      print('Error : $e');
    }
  }
}
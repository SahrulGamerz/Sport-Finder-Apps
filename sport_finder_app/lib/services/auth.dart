import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sport_finder_app/models/user.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on User?
  UserInfoRetrieve? _user(User? user){
    return user != null ? UserInfoRetrieve(uid: user.uid, emailVerified: user.emailVerified) : null;
  }

  //auth change user stream
  Stream<UserInfoRetrieve?> get user {
    return _auth.authStateChanges()
        .map((User? user) => _user(user));
  }

  //sign in anon
  Future signInAnon() async {
    try{
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;
      return _user(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in email & password
  Future signInEmailPass(String email, String password) async {
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      print(user);
      return _user(user);
    }catch(e){
      print(e.toString());
      if(e.toString() == "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.")
        return "NotFound";
      if(e.toString() == "[firebase_auth/wrong-password] The password is invalid or the user does not have a password." || e.toString() == "[firebase_auth/unknown] Given String is empty or null")
        return "WrongPassword";
      if(e.toString() == "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.")
        return "RateLimited";
      return null;
    }
  }

  //register with email & password (awie wat sini eh)


  //verification
  Future verification() async{
    try{
      User? user = _auth.currentUser;
      if(user != null) {
        await user.sendEmailVerification();
      }
      return true;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //refresh user account
  Future refreshUser() async{
    try{
      User? user = _auth.currentUser;
      if(user != null) {
        await user.reload();
      }
      return _user(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}
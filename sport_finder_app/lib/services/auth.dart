import 'dart:async';
import '../models/globalVariables.dart' as userDataClass;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sport_finder_app/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //create user object based on User?
  UserInfoRetrieve? _user(User? user) {
    return user != null
        ? UserInfoRetrieve(uid: user.uid, emailVerified: user.emailVerified)
        : null;
  }

  //auth change user stream
  Stream<UserInfoRetrieve?> get user {
    return _auth.authStateChanges().map((User? user) => _user(user));
  }

  //sign in email & password
  Future signInEmailPass(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      print(user);
      if (user != null) {
        CollectionReference users = firestore.collection('users');
        await users
            .doc(user.uid)
            .update({
              'last_login_at': DateTime.now(),
            })
            .then((value) => print("success"))
            .catchError((error) => print("Failed to update user: $error"));
        DocumentSnapshot userData = await users.doc(user.uid).get();
        Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
        userDataClass.isAdmin = data['isAdmin'];
        userDataClass.uid = user.uid;
        userDataClass.username = data['username'];
      }
      return _user(user);
    } catch (e) {
      print(e.toString());
      if (e.toString() ==
          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.")
        return "NotFound";
      if (e.toString() ==
              "[firebase_auth/wrong-password] The password is invalid or the user does not have a password." ||
          e.toString() ==
              "[firebase_auth/unknown] Given String is empty or null")
        return "WrongPassword";
      if (e.toString() ==
          "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.")
        return "RateLimited";
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(
      String username, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        CollectionReference users = firestore.collection('users');
        await users.doc(user.uid).set({
          'uid': user.uid,
          'username': username,
          'email': email,
          'profile_picture': 'https://picsum.photos/seed/298/600',
          'background_image': 'https://picsum.photos/seed/857/600',
          'bio': 'Hey there!',
          'phoneNumber': '000-000 0000',
          'playerType': 'Anything',
          'isAdmin': false,
          'created_at': DateTime.now(),
          'last_updated_at': DateTime.now(),
          'last_login_at': DateTime.now(),
        });
      }
      return _user(user);
    } catch (e) {
      print(e.toString());
      if (e.toString() ==
          "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.")
        return "RateLimited";
      if (e.toString() ==
          "[firebase_auth/email-already-in-use] The email address is already in use by another account.")
        return "AccountExist";
      return null;
    }
  }

  //Forgot Password
  Future forgotPassword(email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print(e.toString());
      if (e.toString() ==
          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.")
        return "NotFound";
      if (e.toString() ==
          "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.")
        return "RateLimited";
      return null;
    }
  }

  //verification
  Future verification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
      }
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //refresh user account
  Future refreshUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.reload();
      }
      if (user != null) {
        CollectionReference users = firestore.collection('users');
        await users
            .doc(user.uid)
            .update({
              'last_seen_at': DateTime.now(),
            })
            .then((value) => print("success"))
            .catchError((error) => print("Failed to update user: $error"));
        DocumentSnapshot userData = await users.doc(user.uid).get();
        Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
        userDataClass.isAdmin = data['isAdmin'];
        userDataClass.uid = user.uid;
        userDataClass.username = data['username'];
      }
      return _user(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //get other user userData
  Future getOtherUserData(String uid) async {
    try {
      CollectionReference users = firestore.collection('users');
      DocumentSnapshot userData = await users.doc(uid).get();
      Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //get user data
  Future getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        try {
          CollectionReference users = firestore.collection('users');
          DocumentSnapshot userData = await users.doc(user.uid).get();
          Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
          return data;
        } catch (e) {
          print(e.toString());
          return null;
        }
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //update user data
  Future updateUserData(String username, String bio, String phoneNumber,
      String playerType, String pp, String bg) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        try {
          bool result = false;
          CollectionReference users = firestore.collection('users');
          await users
              .doc(user.uid)
              .update({
                'username': username,
                'profile_picture': pp,
                'background_image': bg,
                'bio': bio,
                'phoneNumber': phoneNumber,
                'playerType': playerType,
                'last_updated_at': DateTime.now(),
              })
              .then((value) => result = true)
              .catchError((error) => result = false);
          return result;
        } catch (e) {
          print(e.toString());
          return null;
        }
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //change password
  Future changePassword(String password) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        await user.updatePassword(password);
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      if (e.toString() ==
          "[firebase_auth/requires-recent-login] This operation is sensitive and requires recent authentication. Log in again before retrying this request.")
        return "ReLog";
      return null;
    }
  }

  //ReAuthenticateWithCredential
  Future reAuthenticateUser(String email, String password) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        AuthCredential credential =
            EmailAuthProvider.credential(email: email, password: password);
        await user.reauthenticateWithCredential(credential);
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

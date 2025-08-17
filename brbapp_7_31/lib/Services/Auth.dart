import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../assets/brbGlobals.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  dynamic authFire;
  // final user = FirebaseAuth.instance.currentUser;

  Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      //print("You are in");
    } on FirebaseAuthException {
      // handle error
    }
  }

  Future<void> googleLogin(context) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        MyAlert(context, 'Not signed in');
        return;
      }
      final googleAuth = await googleUser.authentication;
      // I just added await here Rohan

      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      //MyAlert(context,'this is googleusers ${googleAuth.idToken.toString()}');
      await FirebaseAuth.instance.signInWithCredential(authCredential);
      print('we are in');
      fireuserEmail = getemail(
        context,
      ); //////////////////////////////////////////////////////
      updateIcon(context);
      //authFire=getemail(context);
    } on FirebaseAuthException catch (e) {
      MyAlert(context, 'Not Authenticated ${e.message}');
      Navigator.pop(context);
      // handle error
    }
  }

  Future<void> signOut() async {
    //await GoogleSignIn().disconnect(); // forces new sign
    await FirebaseAuth.instance.signOut();
  }

  newUser(context) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        MyAlert(context, 'Not signed in');
        return;
      }

      final googleAuth = await googleUser.authentication;
      // I just added await here Rohan

      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // MyAlert(context,'this is googleusers ${googleAuth.idToken.toString()}');
      await FirebaseAuth.instance.signInWithCredential(authCredential);
    } on FirebaseAuthException catch (e) {
      MyAlert(context, 'Not Authenticated ${e.message}');
      // handle error
    }

    await GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut();
  }

  getemail(context) {
    final newuser =
        FirebaseAuth.instance.currentUser?.email ??
        (throw Exception("Value cannot be null!"));
    print('this is email $newuser');
    return newuser;
  }
}

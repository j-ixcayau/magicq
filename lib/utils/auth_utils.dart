import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:google_sign_in/google_sign_in.dart';

class AuthUtils {
  static Future<void> auth() async {
    if (kIsWeb) {
      // Web login flow
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } else {
      // Android login flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Authenticate with Firebase

      await FirebaseAuth.instance.signInWithCredential(credential);
    }

    log('Successfully logged in: ${FirebaseAuth.instance.currentUser?.displayName}');
  }
}

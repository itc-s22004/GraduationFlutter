import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omg/auth_controller.dart';
import 'package:get/get.dart';
import 'package:omg/registration/addinfo.dart';

class GoogleSignUpPage extends StatefulWidget {
  const GoogleSignUpPage({Key? key}) : super(key: key);

  @override
  _GoogleSignUpPageState createState() => _GoogleSignUpPageState();
}

class _GoogleSignUpPageState extends State<GoogleSignUpPage> {
  final AuthController authController = Get.put(AuthController());
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Google SignIn Error: $e");
      return null;
    }
  }

  void _handleGoogleSignUp() async {
    final user = await _signInWithGoogle();
    if (user != null) {
      final userCollection = FirebaseFirestore.instance.collection('users');
      final userCount = (await userCollection.get()).size + 1;
      String userId = 'user$userCount';

      await userCollection.doc(userId).set({
        'id': userCount,
        'email': user.email,
        'diagnosis': '',
        'gender': '',
        'school': '',
        'introduction': '',
      });

      authController.updateEmail(user.email!);
      authController.updateUserId(userCount);

      await authController.fetchUserData();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AddInfo(data: user.email!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Googleアカウントでのサインインに失敗しました')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Googleで登録')),
      body: Center(
        child: ElevatedButton.icon(
          icon: Icon(Icons.login),
          label: Text("Googleでサインイン"),
          onPressed: _handleGoogleSignUp,
        ),
      ),
    );
  }
}

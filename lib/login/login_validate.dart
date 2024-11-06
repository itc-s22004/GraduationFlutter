import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:omg/registration/create_account.dart';
import '../auth_controller.dart';
import '../mbti/mbti.dart';
import '../registration/addinfo.dart';
import '../navigation.dart';

class LoginValidate extends StatefulWidget {
  const LoginValidate({Key? key}) : super(key: key);

  @override
  State<LoginValidate> createState() => _LoginValidateState();
}

class _LoginValidateState extends State<LoginValidate> {
  bool _isObscure = true;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JboyApp'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'メールアドレスが入力されていません!';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'MAIL ADDRESS',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'パスワードが入力されていません!';
                      }
                      return null;
                    },
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        try {
                          // Firebase Authenticationでログイン
                          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );

                          authController.updateEmail(emailController.text);

                          final snapshot = await FirebaseFirestore.instance
                              .collection('users')
                              .where('email', isEqualTo: emailController.text)
                              .get();

                          if (snapshot.docs.isNotEmpty) {
                            final userData = snapshot.docs.first.data();
                            final userId = userData['id'] ?? 0;
                            authController.updateUserId(userId);

                            authController.updateSchool(userData['school'] ?? '');
                            authController.updateDiagnosis(userData['diagnosis'] ?? '');
                            authController.updateGender(userData['gender'] ?? '');

                            if (userData['tag'] != null) {
                              List<String> userTags = List<String>.from(userData['tag']);
                              authController.updateTags(userTags);
                            }
                          }

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const BottomNavigation()),
                          );

                        } on FirebaseAuthException catch (e) {
                          String message;
                          if (e.code == 'user-not-found') {
                            message = 'ユーザーが見つかりません';
                          } else if (e.code == 'wrong-password') {
                            message = 'パスワードが間違っています';
                          } else {
                            message = 'ログインに失敗しました';
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message)),
                          );
                        }
                      }
                    },
                    child: const Text('ログイン'),
                  ),
                ),


                const SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreateAccountPage()),
                      );
                    },
                    child: const Text('アカウント作成'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
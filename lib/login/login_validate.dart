import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:omg/registration/create_account.dart';
import '../auth_controller.dart';
import '../navigation.dart';
import '../utilities/constant.dart';

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
        title: const Text(
          'Log in',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.elliptical(90, 30),
          ),
        ),
        backgroundColor: kAppBarBackground,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: 500,
            color: kAppBtmBackground,
          ),
          Container(
            height: 500,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(200),
              ),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          Center(
            child: SizedBox(
              width: 420,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                color: kObjectBackground,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Log in to your account",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'メールアドレスが入力されていません!';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'メールアドレス',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.email_outlined),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
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
                              labelText: 'パスワード',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "or continue with",
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),

                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Googleログインの処理をここに追加  ---------------------
                            },
                            icon: SvgPicture.asset(
                              'assets/svg/web_neutral_rd_na.svg',
                              height: 34,
                              width: 34,
                            ),
                            label: const Text(
                              "Log in with Google       ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(350, 40),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 45),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                textStyle: const TextStyle(fontSize: 18),
                                fixedSize: const Size(350, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // backgroundColor: Colors.indigo
                                backgroundColor: kAppBtmBackground
                            ),
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                try {
                                  // Firebase Authenticationでログイン
                                  UserCredential userCredential = await FirebaseAuth
                                      .instance
                                      .signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );

                                  authController.updateEmail(emailController.text);

                                  final snapshot = await FirebaseFirestore
                                      .instance
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
                                    authController.updateIntroduction(userData['introduction'] ?? '');

                                    if (userData['tag'] != null) {
                                      List<String> userTags = List<String>.from(userData['tag']);
                                      authController.updateTags(userTags);
                                    }
                                  }

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const BottomNavigation()),
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
                            // child: const Text('Log in'),
                            child: const Text(
                              "ログイン",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CreateAccountPage()),
                              );
                            },
                            child: const Text(
                              'アカウント作成',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
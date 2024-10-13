import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omg/login/loginNext.dart';

import '../auth_controller.dart';
import '../with.dart';

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

  // AuthControllerのインスタンスを取得
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
                        return 'ユーザー名が入力されていません!';
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

                          // ログイン成功後、メールアドレスを保存
                          authController.updateEmail(emailController.text);

                          // FirestoreからユーザーIDを取得
                          final snapshot = await FirebaseFirestore.instance
                              .collection('users')
                              .where('email', isEqualTo: emailController.text)
                              .get();

                          if (snapshot.docs.isNotEmpty) {
                            final userId = snapshot.docs.first.data()['id'] ?? 0;
                            authController.updateUserId(userId); // ユーザーIDを保存
                          }

                          // ログイン成功メッセージ
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('ログイン成功')),
                          );

                          // 次のページへ遷移
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MainApp())
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:omg/login/loginNext.dart';
// import 'package:omg/with.dart';
//
// // Controller class
// class AuthController extends GetxController {
//   var email = ''.obs; // Emailを保持するRx
//
//   void updateEmail(String newEmail) {
//     email.value = newEmail; // Emailの値を更新
//   }
// }
//
// class LoginValidate extends StatefulWidget {
//   const LoginValidate({Key? key}) : super(key: key);
//
//   @override
//   State<LoginValidate> createState() => _LoginValidateState();
// }
//
// class _LoginValidateState extends State<LoginValidate> {
//   bool _isObscure = true;
//   final _formkey = GlobalKey<FormState>();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   // AuthControllerのインスタンスを作成
//   final AuthController authController = Get.put(AuthController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('JboyApp'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.all(30.0),
//           child: Form(
//             key: _formkey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//                   child: TextFormField(
//                     controller: emailController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'ユーザー名が入力されていません!';
//                       }
//                       return null;
//                     },
//                     decoration: const InputDecoration(
//                       labelText: 'MAIL ADDRESS',
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//                   child: TextFormField(
//                     controller: passwordController,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'パスワードが入力されていません!';
//                       }
//                       return null;
//                     },
//                     obscureText: _isObscure,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       suffixIcon: IconButton(
//                         icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
//                         onPressed: () {
//                           setState(() {
//                             _isObscure = !_isObscure;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       if (_formkey.currentState!.validate()) {
//                         try {
//                           // Firebase Authenticationでログイン
//                           UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//                             email: emailController.text,
//                             password: passwordController.text,
//                           );
//
//                           // ログイン成功後の処理
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('ログイン成功')),
//                           );
//
//                           // メールアドレスをRxに保存
//                           authController.updateEmail(emailController.text);
//
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => const MainApp()
//                               )
//                           );
//                         } on FirebaseAuthException catch (e) {
//                           // エラー処理
//                           String message;
//                           if (e.code == 'user-not-found') {
//                             message = 'ユーザーが見つかりません';
//                           } else if (e.code == 'wrong-password') {
//                             message = 'パスワードが間違っています';
//                           } else {
//                             message = 'ログインに失敗しました';
//                           }
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text(message)),
//                           );
//                         }
//                       }
//                     },
//                     child: Text('ログイン'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


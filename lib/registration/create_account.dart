import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:omg/auth_controller.dart';
import 'package:omg/mbti/mbti.dart';
import 'package:omg/registration/addinfo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  CreateAccountPageState createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _agreeToTerms = false;

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント作成',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'メールアドレス',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'パスワード（英数字6文字以上）',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            // TextField(
            //   controller: _confirmPasswordController,
            //   decoration: const InputDecoration(
            //     labelText: 'パスワード（確認用）',
            //     border: OutlineInputBorder(),
            //   ),
            //   obscureText: true,
            // ),
            // const SizedBox(height: 16),
            // TextField(
            //   controller: _usernameController,
            //   decoration: const InputDecoration(
            //     labelText: 'ユーザー名',
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            // const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreeToTerms = value!;
                      });
                    },
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '利用規約',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              const url = '利用規約ページのURL';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('URLを開けませんでした')),
                                );
                              }
                            },
                        ),
                        const TextSpan(text: 'を確認の上、同意する'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'プライバシーポリシー',
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        const url = 'プライバシーポリシーページのURL';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('URLを開けませんでした')),
                          );
                        }
                      },
                  ),
                  const TextSpan(text: 'を読む'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _createAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('登録', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    // if (_passwordController.text != _confirmPasswordController.text) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('パスワードが一致しません')),
    //   );
    //   return;
    // }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('利用規約に同意してください')),
      );
      return;
    }

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final userCollection = FirebaseFirestore.instance.collection('users');
      final snapshot = await userCollection.get();
      final userCount = snapshot.size + 1;

      String userId = 'user$userCount';
      String username = _usernameController.text.trim();

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'id': userCount,
        'email': _emailController.text.trim(),
        'diagnosis': null,
        'gender': null,
        'school': null
      });

      await userCredential.user?.updateDisplayName(username);
      await userCredential.user?.sendEmailVerification();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddInfo(data: _emailController.text)),
        // MaterialPageRoute(builder: (context) => Mbti(data: _emailController.text)),
      );

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('アカウント作成に失敗しました: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('予期せぬエラーが発生しました: $e')),
      );
    }
  }
}
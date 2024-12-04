import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:omg/auth_controller.dart';
import 'package:omg/comp/tag.dart';
import 'package:omg/mbti/mbti.dart';
import 'package:omg/registration/addinfo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utilities/constant.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  CreateAccountPageState createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {
  // final _emailController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _agreeToTerms = false;
  bool _isObscure = true;
  bool _isObscureSub = true;

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign up',
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
                          "Create an account",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'メールアドレス',
                              suffixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            labelText: 'パスワード（英数字6文字以上）',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
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
                          // obscureText: true,
                        ),
                        const SizedBox(height: 26),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: _isObscureSub,
                          decoration: InputDecoration(
                            labelText: 'パスワード（確認用）',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscureSub
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscureSub = !_isObscureSub;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          // obscureText: true,
                        ),
                        const SizedBox(height: 26),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content:
                                                      Text('URLを開けませんでした')),
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
                        Center(
                          child: Text.rich(
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text('URLを開けませんでした')),
                                        );
                                      }
                                    },
                                ),
                                const TextSpan(text: 'を読む'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _createAccount,
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
                          child: const Text('登録',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
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
                              "Sign up with Google       ",
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: const Text(
  //           '新規登録',
  //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //         ),
  //         shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.only(
  //             bottomRight: Radius.elliptical(90, 30),
  //           ),
  //         ),
  //         backgroundColor: kAppBarBackground,
  //         elevation: 0,
  //       ),
  //       body: Stack(children: [
  //         Container(
  //           height: 500,
  //           color: kAppBtmBackground,
  //         ),
  //         Container(
  //           height: 500,
  //           decoration: BoxDecoration(
  //             borderRadius: const BorderRadius.only(
  //               topLeft: Radius.circular(200),
  //             ),
  //             color: Theme.of(context).scaffoldBackgroundColor,
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: SingleChildScrollView(
  //             // 内容が長くなった時にスクロールできるように
  //             child: Column(
  //               children: [
  //                 // Cardでラップして表示
  //                 Card(
  //                   elevation: 5, // 影をつける
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8), // 角丸
  //                   ),
  //                   margin: const EdgeInsets.symmetric(vertical: 10),
  //                   color: kObjectBackground,
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(16.0),
  //                     child: Column(
  //                       children: [
  //                         Text(
  //                           "Create an account",
  //                           style: TextStyle(
  //                             fontSize: 26,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.green[700],
  //                           ),
  //                         ),
  //                         const SizedBox(height: 30),
  //                         TextField(
  //                           controller: emailController,
  //                           decoration: const InputDecoration(
  //                             labelText: 'メールアドレス',
  //                             suffixIcon: Icon(Icons.email_outlined),
  //                             border: OutlineInputBorder(),
  //                             filled: true,
  //                             fillColor: Colors.white,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 16),
  //                         TextField(
  //                           controller: _passwordController,
  //                           decoration: InputDecoration(
  //                             labelText: 'パスワード（英数字6文字以上）',
  //                             border: const OutlineInputBorder(),
  //                             suffixIcon: IconButton(
  //                               icon: Icon(
  //                                 _isObscure ? Icons.visibility_off : Icons.visibility,
  //                               ),
  //                               onPressed: () {
  //                                 setState(() {
  //                                   _isObscure = !_isObscure;
  //                                 });
  //                               },
  //                             ),
  //                             filled: true,
  //                             fillColor: Colors.white,
  //                           ),
  //                           obscureText: true,
  //                         ),
  //                         const SizedBox(height: 16),
  //                         TextField(
  //                           controller: _confirmPasswordController,
  //                           decoration: InputDecoration(
  //                             labelText: 'パスワード（確認用）',
  //                             border: const OutlineInputBorder(),
  //                             suffixIcon: IconButton(
  //                               icon: Icon(
  //                                 _isObscure ? Icons.visibility_off : Icons.visibility,
  //                               ),
  //                               onPressed: () {
  //                                 setState(() {
  //                                   _isObscure = !_isObscure;
  //                                 });
  //                               },
  //                             ),
  //                             filled: true,
  //                             fillColor: Colors.white,
  //                           ),
  //                           obscureText: true,
  //                         ),
  //                         const SizedBox(height: 16),
  //                         Container(
  //                           decoration: BoxDecoration(
  //                             color: Colors.white,
  //                             border: Border.all(color: Colors.blue, width: 2),
  //                             borderRadius: BorderRadius.circular(8),
  //                           ),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               Checkbox(
  //                                 value: _agreeToTerms,
  //                                 onChanged: (value) {
  //                                   setState(() {
  //                                     _agreeToTerms = value!;
  //                                   });
  //                                 },
  //                               ),
  //                               Text.rich(
  //                                 TextSpan(
  //                                   children: [
  //                                     TextSpan(
  //                                       text: '利用規約',
  //                                       style: const TextStyle(
  //                                         color: Colors.blue,
  //                                         decoration: TextDecoration.underline,
  //                                       ),
  //                                       recognizer: TapGestureRecognizer()
  //                                         ..onTap = () async {
  //                                           const url = '利用規約ページのURL';
  //                                           if (await canLaunch(url)) {
  //                                             await launch(url);
  //                                           } else {
  //                                             ScaffoldMessenger.of(context)
  //                                                 .showSnackBar(
  //                                               const SnackBar(
  //                                                   content:
  //                                                       Text('URLを開けませんでした')),
  //                                             );
  //                                           }
  //                                         },
  //                                     ),
  //                                     const TextSpan(text: 'を確認の上、同意する'),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         const SizedBox(height: 8),
  //                         Text.rich(
  //                           TextSpan(
  //                             children: [
  //                               TextSpan(
  //                                 text: 'プライバシーポリシー',
  //                                 style: const TextStyle(
  //                                   color: Colors.blue,
  //                                   decoration: TextDecoration.underline,
  //                                 ),
  //                                 recognizer: TapGestureRecognizer()
  //                                   ..onTap = () async {
  //                                     const url = 'プライバシーポリシーページのURL';
  //                                     if (await canLaunch(url)) {
  //                                       await launch(url);
  //                                     } else {
  //                                       ScaffoldMessenger.of(context)
  //                                           .showSnackBar(
  //                                         const SnackBar(
  //                                             content: Text('URLを開けませんでした')),
  //                                       );
  //                                     }
  //                                   },
  //                               ),
  //                               const TextSpan(text: 'を読む'),
  //                             ],
  //                           ),
  //                         ),
  //                         const SizedBox(height: 16),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //
  //                 // 登録ボタン
  //                 ElevatedButton(
  //                   onPressed: _createAccount,
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.blue,
  //                     minimumSize: const Size(double.infinity, 50),
  //                   ),
  //                   child: const Text('登録',
  //                       style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.bold)),
  //                 ),
  //                 const SizedBox(height: 16),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ]));
  // }

  //----------------------------------------

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('アカウント作成',
  //           style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold)),
  //       backgroundColor: Colors.blue,
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           TextField(
  //             // controller: _emailController,
  //             controller: emailController,
  //             decoration: const InputDecoration(
  //               labelText: 'メールアドレス',
  //               border: OutlineInputBorder(),
  //             ),
  //           ),
  //           const SizedBox(height: 16),
  //           TextField(
  //             controller: _passwordController,
  //             decoration: const InputDecoration(
  //               labelText: 'パスワード（英数字6文字以上）',
  //               border: OutlineInputBorder(),
  //             ),
  //             obscureText: true,
  //           ),
  //           const SizedBox(height: 16),
  //           TextField(
  //             controller: _confirmPasswordController,
  //             decoration: const InputDecoration(
  //               labelText: 'パスワード（確認用）',
  //               border: OutlineInputBorder(),
  //             ),
  //             obscureText: true,
  //           ),
  //           const SizedBox(height: 16),
  //           Container(
  //             decoration: BoxDecoration(
  //               border: Border.all(color: Colors.blue, width: 2),
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Checkbox(
  //                   value: _agreeToTerms,
  //                   onChanged: (value) {
  //                     setState(() {
  //                       _agreeToTerms = value!;
  //                     });
  //                   },
  //                 ),
  //                 Text.rich(
  //                   TextSpan(
  //                     children: [
  //                       TextSpan(
  //                         text: '利用規約',
  //                         style: const TextStyle(
  //                           color: Colors.blue,
  //                           decoration: TextDecoration.underline,
  //                         ),
  //                         recognizer: TapGestureRecognizer()
  //                           ..onTap = () async {
  //                             const url = '利用規約ページのURL';
  //                             if (await canLaunch(url)) {
  //                               await launch(url);
  //                             } else {
  //                               ScaffoldMessenger.of(context).showSnackBar(
  //                                 const SnackBar(content: Text('URLを開けませんでした')),
  //                               );
  //                             }
  //                           },
  //                       ),
  //                       const TextSpan(text: 'を確認の上、同意する'),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const SizedBox(height: 8),
  //           Text.rich(
  //             TextSpan(
  //               children: [
  //                 TextSpan(
  //                   text: 'プライバシーポリシー',
  //                   style: const TextStyle(
  //                     color: Colors.blue,
  //                     decoration: TextDecoration.underline,
  //                   ),
  //                   recognizer: TapGestureRecognizer()
  //                     ..onTap = () async {
  //                       const url = 'プライバシーポリシーページのURL';
  //                       if (await canLaunch(url)) {
  //                         await launch(url);
  //                       } else {
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           const SnackBar(content: Text('URLを開けませんでした')),
  //                         );
  //                       }
  //                     },
  //                 ),
  //                 const TextSpan(text: 'を読む'),
  //               ],
  //             ),
  //           ),
  //           const SizedBox(height: 16),
  //           ElevatedButton(
  //             onPressed: _createAccount,
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.blue,
  //               minimumSize: const Size(double.infinity, 50),
  //             ),
  //             child: const Text('登録', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
  //           ),
  //           const SizedBox(height: 16),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('パスワードが一致しません')),
      );
      return;
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final userCollection = FirebaseFirestore.instance.collection('users');
      final userCount = (await userCollection.get()).size + 1;

      String userId = 'user$userCount';

      await userCollection.doc(userId).set({
        'id': userCount,
        'email': emailController.text.trim(),
        'diagnosis': '',
        'gender': '',
        'school': '',
        'introduction': '',
      });

      authController.updateEmail(emailController.text.trim());
      authController.updateUserId(userCount);

      await authController.fetchUserData(); // 登録後すぐにデータを取得し更新

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddInfo(data: emailController.text)),
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

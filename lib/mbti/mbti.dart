import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omg/login/loginNext.dart';
import 'package:omg/login/login_validate.dart';
import 'package:omg/next.dart';
import 'package:omg/with.dart';

class Diagnosis extends StatefulWidget {
  final String data;  // emailを保持
  const Diagnosis({super.key, required this.data});

  @override
  _DiagnosisState createState() => _DiagnosisState();
}

class _DiagnosisState extends State<Diagnosis> {
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();

  @override
  void dispose() {
    _genderController.dispose();
    _schoolController.dispose();
    _diagnosisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('追加情報入力'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('email: ${widget.data}'),
            const SizedBox(height: 16),
            TextField(
              controller: _genderController,
              decoration: const InputDecoration(
                labelText: '性別',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _schoolController,
              decoration: const InputDecoration(
                labelText: '学校',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _diagnosisController,
              decoration: const InputDecoration(
                labelText: '診断結果',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateUserData,
              child: const Text('情報を更新'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigatorのpushを使用する際に異なるキーが必要
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // builder: (context) => const MainApp(), // 次のページへ遷移
                    builder: (context) => const LoginNext()
                  ),
                );
              },
              child: const Text("登録"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _updateUserData() async {
    // Firestoreのドキュメントを更新
    try {
      await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: widget.data).get().then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // ドキュメントIDを取得して更新
          String docId = querySnapshot.docs.first.id;
          FirebaseFirestore.instance.collection('users').doc(docId).update({
            'gender': _genderController.text.trim(),
            'school': _schoolController.text.trim(),
            'diagnosis': _diagnosisController.text.trim(),
          });
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ユーザー情報が更新されました')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:omg/auth_controller.dart';

import '../auth_controller.dart';

class Mbti extends StatefulWidget {
  final String data;
  const Mbti({super.key, required this.data});

  @override
  _MbtiState createState() => _MbtiState();
}

class _MbtiState extends State<Mbti> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _setKeys = List.generate(12, (_) => GlobalKey());
  final List<int?> _selectedIndexes = List.generate(12, (_) => null);
  final AuthController authController = Get.find<AuthController>();

  List<String> questions = List.generate(12, (_) => "");

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchQuestions() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('mbti').get();
    final docs = querySnapshot.docs;

    for (var i = 0; i < docs.length && i < questions.length; i++) {
      questions[i] = docs[i].get('sentence') ?? "質問が見つかりません";
    }

    setState(() {});
  }

  void _scrollToNextSet(int setIndex) {
    final context = _setKeys[setIndex].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onButtonPressed(int setIndex, int buttonIndex) {
    setState(() {
      _selectedIndexes[setIndex] = buttonIndex;
    });
    if (setIndex < _setKeys.length - 1) {
      _scrollToNextSet(setIndex + 1);
    }
  }

  void _onConfirm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("選択結果"),
          content: Text("選択されたボタン: ${_selectedIndexes.where((index) => index != null).map((index) => index! + 1).toList().join(', ')}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("閉じる"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MBTI 診断"),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('email: ${widget.data}'),
            for (int setIndex = 0; setIndex < _setKeys.length; setIndex++)
              Container(
                key: _setKeys[setIndex],
                margin: const EdgeInsets.only(bottom: 700.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40.0),
                      Text(
                        questions[setIndex].isNotEmpty
                            ? "問題 ${setIndex + 1}: ${questions[setIndex]}"
                            : "読み込み中...",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      for (int buttonIndex = 0; buttonIndex < 4; buttonIndex++)
                        Container(
                          margin: const EdgeInsets.only(bottom: 30.0, top: 20.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedIndexes[setIndex] == buttonIndex
                                  ? Colors.blue
                                  : Colors.white,
                            ),
                            onPressed: () {
                              _onButtonPressed(setIndex, buttonIndex);
                            },
                            child: Text("Set ${setIndex + 1} - Button ${buttonIndex + 1}"),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            if (_selectedIndexes.every((index) => index != null))
              ElevatedButton(
                onPressed: _onConfirm,
                child: const Text("決定"),
              ),
          ],
        ),
      ),
    );
  }
}
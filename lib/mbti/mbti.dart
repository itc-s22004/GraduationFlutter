import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:omg/auth_controller.dart';
import 'package:omg/navigation.dart';

import '../utilities/constant.dart';

class Mbti extends StatefulWidget {
  final String data;
  final bool fromEditProf;

  const Mbti({super.key, required this.data, required this.fromEditProf});

  @override
  _MbtiState createState() => _MbtiState();
}

class _MbtiState extends State<Mbti> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _setKeys = List.generate(9, (_) => GlobalKey());
  final List<int?> _selectedIndexes = List.generate(9, (_) => null);
  final AuthController authController = Get.find<AuthController>();

  List<String> questions = List.generate(9, (_) => "");

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

  Future<void> _updateUserDate(String diagnosisResult) async {
    // String animalName = _convertToAnimal(diagnosisResult);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.data)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;
          String docId = userDoc.id;

          FirebaseFirestore.instance.collection('users').doc(docId).update({
            'diagnosis': diagnosisResult,
            // 'diagnosis': animalName,
          });

          // AuthControllerに診断結果を保存
          authController.updateDiagnosis(diagnosisResult);
          // authController.updateDiagnosis(animalName);

        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    }
  }

  String _convertToAnimal(String diagnosisResult) {
    Map<String, String> animalMap = {
      'ENF': 'うしさん',
      'ENT': 'とりさん',
      'ESF': 'いぬさん',
      'EST': 'さるさん',
      'INF': 'ねこさん',
      'INT': 'はむさん',
      'ISF': 'ひつじさん',
      'IST': 'へびさん',
    };

    return animalMap[diagnosisResult] ?? '不明な結果';
  }

  Future<void> _fetchQuestions() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('mbti').get();
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
        duration: const Duration(milliseconds: 350),
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
    List<int> selected = _selectedIndexes.whereType<int>().toList();
    String resultStr;
    List<List<int>> groupedSelections = [
      selected.sublist(0, 3), // EI
      selected.sublist(3, 6), // SN
      selected.sublist(6, 9), // TF
    ];

    List<String> results = [
      _determineType(groupedSelections[0], 'E', 'I'),
      _determineType(groupedSelections[1], 'S', 'N'),
      _determineType(groupedSelections[2], 'T', 'F'),
    ];

    resultStr = results.join('');

    String animal = _convertToAnimal(resultStr);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("選択結果"),
          content: Text("結果: $animal"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateUserDate(animal); // Firestoreの更新

                // AuthControllerに診断結果を保存
                authController.updateDiagnosis(animal);

                if (widget.fromEditProf) { // trueだったら編集画面に
                  Get.back(); // 編集画面に戻る
                } else {
                  // BottomNavigationに遷移
                  Get.offAll(() => const BottomNavigation());
                }
              },
              child: const Text("閉じる"),  //----------------------------
            ),
          ],
        );
      },
    );
  }

  // 特性判定関数
  String _determineType(List<int> group, String typeA, String typeB) {
    int countTypeA = group.where((index) => index == 0 || index == 1).length;
    int countTypeB = group.where((index) => index == 2 || index == 3).length;
    return countTypeA >= 2
        ? typeA
        : countTypeB >= 2
            ? typeB
            : '';
  }

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MBTI',
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
          Padding(
            padding: const EdgeInsets.only(bottom: 70.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int setIndex = 0; setIndex < _setKeys.length; setIndex++)
                    Container(
                      key: _setKeys[setIndex],
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 5),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            questions[setIndex].isNotEmpty
                                ? "問題 ${setIndex + 1}:\n${questions[setIndex]}"
                                : "読み込み中...",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          for (int buttonIndex = 0; buttonIndex < 4; buttonIndex++)
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedIndexes[setIndex] ==
                                      buttonIndex
                                      ? kQuestBackground
                                      : Colors.grey[200],
                                  foregroundColor:
                                  _selectedIndexes[setIndex] == buttonIndex
                                      ? Colors.black
                                      : Colors.black,
                                  fixedSize: Size(buttonWidth, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () =>
                                    _onButtonPressed(setIndex, buttonIndex),
                                child: Text(
                                  ["　賛成　", "やや賛成", "やや反対", "　反対　"][buttonIndex],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold, // 文字を太字にする
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_selectedIndexes.every((index) => index != null))
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAppBarBackground,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _onConfirm,
                  child: const Text(
                    "決定",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

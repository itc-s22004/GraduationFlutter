import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import 'package:omg/mbti/mbti.dart';
import '../utilities/constant.dart';

class Tag extends StatefulWidget {
  final String email;
  final bool fromEditProf;

  const Tag({Key? key, required this.email, required this.fromEditProf}) : super(key: key);

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  final AuthController authController = Get.find<AuthController>();

  var selectedTags = <String>[];

  final Map<String, List<String>> groupedTags = {
    'お酒': ['ビール', 'ワイン', '日本酒', '焼酎', 'ウィスキー',
      'ジン', 'ウォッカ', '紹興酒', 'マッコリ', 'カクテル', '果実酒'],
    '趣味': ['音楽', '映画', 'ゲーム', 'スポーツ', '旅行', '読書',
      '写真', '料理', 'アート', 'ダンス', 'ハイキング', 'ボードゲーム',
      'ヨガ', 'ギター', 'カラオケ', 'スイーツ', '漫画', 'コーディング',
      'ファッション', 'DIY', 'ペット', 'サイクリング', 'ランニング', '美容',
      'フィットネス', 'ビデオ編集', 'バーベキュー', '釣り', 'パズル'],
  };

  @override
  void initState() {
    super.initState();
    _loadInitialTags();
  }

  Future<void> _loadInitialTags() async {
    try {
      final tagsFromController = authController.tags;
      if (tagsFromController.isNotEmpty) {
        setState(() {
          selectedTags = List<String>.from(tagsFromController);
        });
        return;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        final List<dynamic> tagsFromFirestore = userDoc['tag'] ?? [];
        setState(() {
          selectedTags = tagsFromFirestore.cast<String>();
        });
      }
    } catch (e) {
      print('タグのロード中にエラーが発生しました: $e');
    }
  }

  Future<void> saveTagsToFirebase() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.email)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;
          String docId = userDoc.id;

          FirebaseFirestore.instance
              .collection('users')
              .doc(docId)
              .set({'tag': selectedTags}, SetOptions(merge: true));

          // AuthController にタグを更新
          authController.updateTags(selectedTags);
        }
      });
    } catch (e) {
      print("タグの保存中にエラーが発生しました: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'タグを選択',
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
      body: Align(
        alignment: Alignment.topCenter,
        child: Stack(
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
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50.0),
                  ...groupedTags.entries.map((category) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            category.key,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Wrap(
                            runSpacing: 16,
                            spacing: 16,
                            children: category.value.map((tag) {
                              final isSelected = selectedTags.contains(tag);
                              return InkWell(
                                borderRadius: const BorderRadius.all(Radius.circular(32)),
                                onTap: () {
                                  setState(() {
                                    isSelected
                                        ? selectedTags.remove(tag)
                                        : selectedTags.add(tag);
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 100),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                                    border: Border.all(width: 2, color: Colors.pink),
                                    color: isSelected ? Colors.pinkAccent : null,
                                  ),
                                  child: Text(
                                    tag,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.pinkAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            backgroundColor: Colors.grey[300],
                          ),
                          onPressed: () {
                            setState(() {
                              selectedTags.clear();
                            });
                          },
                          child: const Text('クリア'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            backgroundColor: kAppBarBackground,
                          ),
                          onPressed: () {
                            saveTagsToFirebase();
                            authController.updateTags(selectedTags);

                            if (widget.fromEditProf) {
                              Get.back();
                            } else {
                              Get.offAll(() => Mbti(data: widget.email, fromEditProf: false));
                            }
                          },
                          child: const Text('タグを決定'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
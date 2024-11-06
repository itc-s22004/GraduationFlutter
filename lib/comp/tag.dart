import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import 'package:omg/mbti/mbti.dart';

class Tag extends StatefulWidget {
  final String email; // AddInfoから受け取るemail

  const Tag({Key? key, required this.email}) : super(key: key);

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  final tags = [
    'ビール', 'ワイン', '日本酒', '焼酎', 'ウィスキー',
    'ジン', 'ウォッカ', '紹興酒', 'マッコリ', 'カクテル', '果実酒',
  ];
  final AuthController authController = Get.find<AuthController>();

  var selectedTags = <String>[];

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

          FirebaseFirestore.instance.collection('users').doc(docId).set({
            'tag': selectedTags
          }, SetOptions(merge: true));

          // AuthControllerにタグを更新
          authController.updateTags(selectedTags);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('タグが保存されました。')),
          );
        }
      });
    } catch (e) {
      print("タグの保存中にエラーが発生しました: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('タグの保存に失敗しました')),
      );
    }
  }


  void navigateToMbti() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Mbti(data: widget.email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タグを選択'),
      ),
      body: Column(
        children: [
          Wrap(
            runSpacing: 16,
            spacing: 16,
            children: tags.map((tag) {
              final isSelected = selectedTags.contains(tag);
              return InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(32)),
                onTap: () {
                  setState(() {
                    isSelected ? selectedTags.remove(tag) : selectedTags.add(tag);
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                    border: Border.all(width: 2, color: Colors.pink),
                    color: isSelected ? Colors.pink : null,
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedTags.clear();
                  });
                },
                child: const Text('クリア'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedTags = List.of(tags);
                  });
                },
                child: const Text('すべて'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  saveTagsToFirebase();
                  navigateToMbti(); // 保存後にMBTIへ遷移
                },
                child: const Text('MBTIへ進む'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../auth_controller.dart';
//
// class Tag extends StatefulWidget {
//   @override
//   State<Tag> createState() => _TagState();
//
//   const Tag({Key? key}) : super(key: key);
// }
//
// class _TagState extends State<Tag> {
//   final tags = [
//     'ビール', 'ワイン', '日本酒', '焼酎', 'ウィスキー',
//     'ジン', 'ウォッカ', '紹興酒', 'マッコリ', 'カクテル', '果実酒',
//   ];
//   final AuthController authController = Get.find<AuthController>();
//
//   var selectedTags = <String>[];
//
//   Future<void> saveTagsToFirebase() async {
//     try {
//       final email = authController.email.value ?? '';
//       await FirebaseFirestore.instance
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .get()
//           .then((querySnapshot) {
//         if (querySnapshot.docs.isNotEmpty) {
//           var userDoc = querySnapshot.docs.first;
//           String docId = userDoc.id;
//
//           FirebaseFirestore.instance.collection('users').doc(docId).set({
//             'tag': selectedTags
//           }, SetOptions(merge: true));
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('タグが保存されました。'))
//           );
//         }
//       });
//     } catch (e) {
//       print("タグの保存中にエラーが発生しました: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('タグの保存に失敗しました')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Wrap(
//           runSpacing: 16,
//           spacing: 16,
//           children: tags.map((tag) {
//             final isSelected = selectedTags.contains(tag);
//             return InkWell(
//               borderRadius: const BorderRadius.all(Radius.circular(32)),
//               onTap: () {
//                 setState(() {
//                   isSelected ? selectedTags.remove(tag) : selectedTags.add(tag);
//                 });
//               },
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 100),
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.all(Radius.circular(32)),
//                   border: Border.all(width: 2, color: Colors.pink),
//                   color: isSelected ? Colors.pink : null,
//                 ),
//                 child: Text(
//                   tag,
//                   style: TextStyle(
//                     color: isSelected ? Colors.white : Colors.pink,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   selectedTags.clear();
//                 });
//               },
//               child: const Text('クリア'),
//             ),
//             const SizedBox(width: 16),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   selectedTags = List.of(tags);
//                 });
//               },
//               child: const Text('すべて'),
//             ),
//             const SizedBox(width: 16),
//             ElevatedButton(
//               onPressed: saveTagsToFirebase,
//               child: const Text('保存'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

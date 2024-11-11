import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LikeToList extends StatefulWidget {
  final int currentUserId;

  const LikeToList({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _LikeToListState createState() => _LikeToListState();
}

class _LikeToListState extends State<LikeToList> {
  final RxList<LikeToUser> _likeToUsers = <LikeToUser>[].obs;

  @override
  void initState() {
    super.initState();
    _fetchLikeToUsers();
  }

  Future<void> _fetchLikeToUsers() async {
    try {
      final likeToUsers = <LikeToUser>[];
      final likes = await FirebaseFirestore.instance
          .collection('likes')
          .where('likeTo', isEqualTo: widget.currentUserId)
          .get();

      for (var doc in likes.docs) {
        int likeFromUserId = doc['likeFrom'];

        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: likeFromUserId)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          final userData = userSnapshot.docs.first.data();
          likeToUsers.add(LikeToUser(
            name: userData['email'] ?? '名前なし',
            userId: likeFromUserId,
            likeDocId: doc.id,
          ));
        }
      }

      _likeToUsers.assignAll(likeToUsers);
    } catch (e) {
      print("エラーが発生しました: $e");
    }
  }

  Future<void> _deleteUser(LikeToUser user) async {
    try {
      // Firebaseからの削除
      await FirebaseFirestore.instance
          .collection('likes')
          .doc(user.likeDocId)
          .delete();

      print("ユーザー ${user.userId} の左スワイプデータを削除しました");

      // ローカルリストから削除してUIを更新
      _likeToUsers.remove(user);
    } catch (e) {
      print("削除中にエラーが発生しました: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('あなたをLIKEしたユーザー'),
      ),
      body: Obx(() {
        if (_likeToUsers.isEmpty) {
          return const Center(child: Text("あなたをLIKEしたユーザーがいません"));
        }
        return ListView.builder(
          itemCount: _likeToUsers.length,
          itemBuilder: (context, index) {
            final likeToUser = _likeToUsers[index];
            return Column(
              children: [
                ListTile(
                    title: Text(likeToUser.name),
                    subtitle: Text('ユーザーID: ${likeToUser.userId}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _likeUser(likeToUser.userId);
                          },
                          child: const Text('いいね'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            _deleteUser(likeToUser);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('削除'),
                        ),
                      ],
                    )
                ),
                const Divider(),
              ],
            );
          },
        );
      }),
    );
  }

  Future<void> _likeUser(int likeToUserId) async {
    // いいね機能の処理
  }
}

class LikeToUser {
  final String name;
  final int userId;
  final String likeDocId;

  LikeToUser({
    required this.name,
    required this.userId,
    required this.likeDocId,
  });
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// class LikeToList extends StatefulWidget {
//   final int currentUserId;
//
//   const LikeToList({Key? key, required this.currentUserId}) : super(key: key);
//
//   @override
//   _LikeToListState createState() => _LikeToListState();
// }
//
// class _LikeToListState extends State<LikeToList> {
//   final RxList<LikeToUser> _likeToUsers = <LikeToUser>[].obs;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchLikeToUsers();
//   }
//
//   Future<void> _fetchLikeToUsers() async {
//     try {
//       final likeToUsers = <LikeToUser>[];
//       final likes = await FirebaseFirestore.instance
//           .collection('likes')
//           .where('likeTo', isEqualTo: widget.currentUserId)
//           .get();
//
//       for (var doc in likes.docs) {
//         int likeFromUserId = doc['likeFrom'];
//
//         final userSnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .where('id', isEqualTo: likeFromUserId)
//             .get();
//
//         if (userSnapshot.docs.isNotEmpty) {
//           final userData = userSnapshot.docs.first.data();
//           likeToUsers.add(LikeToUser(
//             name: userData['email'] ?? '名前なし',
//             userId: likeFromUserId,
//             likeDocId: doc.id,
//           ));
//         }
//       }
//
//       _likeToUsers.assignAll(likeToUsers);
//     } catch (e) {
//       print("エラーが発生しました: $e");
//     }
//   }
//
//   Future<void> _likeUser(int likeToUserId) async {
//     try {
//       final likeCollection = FirebaseFirestore.instance.collection('likes');
//
//       await FirebaseFirestore.instance.collection('likes').add({
//         'likeFrom': widget.currentUserId,
//         'likeTo': likeToUserId,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//
//       print("ユーザー ${likeToUserId} にいいねを送りました");
//
//       final reverseLikeSnapshot = await likeCollection
//           .where('likeFrom', isEqualTo: likeToUserId)
//           .where('likeTo', isEqualTo: widget.currentUserId)
//           .get();
//
//       if (reverseLikeSnapshot.docs.isNotEmpty) {
//         await FirebaseFirestore.instance.collection('matches').add({
//           'user1': widget.currentUserId,
//           'user2': likeToUserId,
//           'timestamp': FieldValue.serverTimestamp(),
//         });
//         print("マッチングしました: ${widget.currentUserId} と $likeToUserId");
//
//         for (var doc in reverseLikeSnapshot.docs) {
//           await likeCollection.doc(doc.id).delete();
//         }
//
//         final userLikeSnapshot = await likeCollection
//             .where('likeFrom', isEqualTo: widget.currentUserId)
//             .where('likeTo', isEqualTo: likeToUserId)
//             .get();
//         for (var doc in userLikeSnapshot.docs) {
//           await likeCollection.doc(doc.id).delete();
//         }
//
//         print("マッチしたユーザーのいいねドキュメントを削除しました");
//
//         _likeToUsers.removeWhere((user) => user.userId == likeToUserId);
//       }
//     } catch (e) {
//       print("エラーが発生しました: $e");
//     }
//   }
//
//   // Future<void> _deleteUser(int likeToUserId) async {
//   //   try {
//   //     final likeCollection = FirebaseFirestore.instance.collection('likes');
//   //
//   //     final userLikeSnapshot = await likeCollection
//   //         .where('likeFrom', isEqualTo: widget.currentUserId)
//   //         .where('likeTo', isEqualTo: likeToUserId)
//   //         .get();
//   //
//   //     for (var doc in userLikeSnapshot.docs) {
//   //       await likeCollection.doc(doc.id).delete();
//   //       print("ユーザー ${likeToUserId} のいいねを削除しました");
//   //     }
//   //
//   //     _likeToUsers.removeWhere((user) => user.userId == likeToUserId);
//   //   } catch (e) {
//   //     print("削除中にエラーが発生しました: $e");
//   //   }
//   // }
//
//   Future<void> _deleteUser(LikeToUser user) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('likes')
//           .doc(user.likeDocId)
//           .delete();
//
//       print("ユーザー ${user.userId} の左スワイプデータを削除しました");
//
//       setState(() {
//
//       });
//
//     } catch (e) {
//       print("削除中にエラーが発生しました: $e");
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('あなたをLIKEしたユーザー'),
//       ),
//       body: Obx(() {
//         if (_likeToUsers.isEmpty) {
//           return const Center(child: Text("あなたをLIKEしたユーザーがいません"));
//         }
//         return ListView.builder(
//           itemCount: _likeToUsers.length,
//           itemBuilder: (context, index) {
//             final likeToUser = _likeToUsers[index];
//             return Column(
//               children: [
//                 ListTile(
//                   title: Text(likeToUser.name),
//                   subtitle: Text('ユーザーID: ${likeToUser.userId}'),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () async {
//                           await _likeUser(likeToUser.userId);
//                         },
//                         child: const Text('いいね'),
//                       ),
//                       const SizedBox(width: 8,),
//                       ElevatedButton(
//                         onPressed: () {
//                           _deleteUser(likeToUser.userId as LikeToUser);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                         ),
//                         child: const Text('削除'),
//                       ),
//                     ],
//                   )
//                 ),
//                 const Divider(),
//               ],
//             );
//           },
//         );
//       }),
//     );
//   }
// }
//
// class LikeToUser {
//   final String name;
//   final int userId;
//   final String likeDocId;
//
//   LikeToUser({
//     required this.name,
//     required this.userId,
//     required this.likeDocId,
//   });
// }
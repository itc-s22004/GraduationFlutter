import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import '../utilities/constant.dart';
import 'editProf.dart';

class SettingScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Hello World', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
            // 背景色の部分
            Container(
              height: 500,
              color: kAppBtmBackground,
            ),
            // 背景が丸くなる部分
            Container(
              height: 500,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(200), // 上左側に大きな丸み
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),

            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Obx(() => CircleAvatar(
                            radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: AssetImage("assets/images/${authController.diagnosis.value}.jpg"),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                      ),
                    )),
                    const SizedBox(height: 16),
                    Obx(() => Text(
                      authController.email.value,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )),
                    const SizedBox(height: 24),
                    Divider(color: Colors.grey[300]),

                    // プロフィール情報
                    Obx(() => _buildProfileItem(Icons.person, '性別', authController.gender.value)),
                    Obx(() => _buildProfileItem(Icons.school, '学校', authController.school.value)),
                    Obx(() => _buildProfileItem(Icons.book, '診断', authController.diagnosis.value)),
                    Obx(() => _buildProfileItem(Icons.book, '自己紹介', authController.introduction.value)),

                    const SizedBox(height: 16),
                    Obx(() => _buildTagsSection(authController.tags)),

                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: () {
                        Get.to(() => EditProfileScreen());
                      },
                      child: const Text(
                        '編集',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ), //---------------------
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green[700]),
          const SizedBox(width: 16),
          Text(
            '$label:',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection(List<String> tags) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.label, color: Colors.green),
              SizedBox(width: 16),
              Text(
                'タグ:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                tag,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../auth_controller.dart';
// import 'editProf.dart';
//
// class SettingScreen extends StatelessWidget {
//   final AuthController authController = Get.find<AuthController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('プロフィール'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Obx(() => CircleAvatar(
//               radius: 50,
//               backgroundImage: AssetImage("assets/images/${authController.diagnosis.value}.jpg"),
//             )),
//             const SizedBox(height: 16),
//             Obx(() => Text(
//               authController.email.value,
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             )),
//             const SizedBox(height: 24),
//             Divider(color: Colors.grey[300]),
//
//             Obx(() => _buildProfileItem(Icons.person, '性別', authController.gender.value)),
//             Obx(() => _buildProfileItem(Icons.school, '学校', authController.school.value)),
//             Obx(() => _buildProfileItem(Icons.book, '診断', authController.diagnosis.value)),
//             Obx(() => _buildProfileItem(Icons.book, '自己紹介', authController.introduction.value)),
//
//             Obx(() => _buildTagsSection(authController.tags)),
//
//             OutlinedButton(
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: Colors.black,
//                 shape: const StadiumBorder(),
//                 side: const BorderSide(color: Colors.green),
//               ),
//               onPressed: () {
//                 Get.to(() => EditProfileScreen());
//               },
//               child: const Text('編集'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileItem(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.blueGrey),
//           const SizedBox(width: 16),
//           Text(
//             '$label:',
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 18),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTagsSection(List<String> tags) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             children: [
//               Icon(Icons.label, color: Colors.blueGrey),
//               SizedBox(width: 16),
//               Text(
//                 'タグ:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Wrap(
//             spacing: 8.0,
//             runSpacing: 4.0,
//             children: tags.map((tag) => Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Text(
//                 tag,
//                 style: const TextStyle(fontSize: 18),
//               ),
//             )).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }
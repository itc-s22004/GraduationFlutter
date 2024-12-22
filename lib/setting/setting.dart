import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth_controller.dart';
import '../comp/detailDesgin.dart';
import '../utilities/constant.dart';
import 'editProf.dart';

class SettingScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    const double cardSize = 220.0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'プロフィール',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.elliptical(90, 30),
          ),
        ),
        centerTitle: false,
        backgroundColor: kAppBarBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Get.to(() => const EditProfileScreen());
            },
          ),
        ],
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
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20.0, left: 10.0),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9 > 460
                            ? 460
                            : MediaQuery.of(context).size.width * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(() => CircleAvatar(
                              radius: 40.0,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(
                                  "assets/images/${authController.diagnosis.value}.png"),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 4),
                                ),
                              ),
                            )),
                            const SizedBox(width: 24),
                            Obx(() => Text(
                              authController.email.value,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            )),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey[300]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => buildInfoCard(
                          context,
                          Icons.person,
                          '性別',
                          authController.gender.value,
                          cardSize,
                        )),
                        const SizedBox(width: 24),
                        Obx(() => buildInfoCard(
                          context,
                          Icons.school,
                          '得意言語',
                          authController.school.value,
                          cardSize,
                        )),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => buildInfoCard(
                          context,
                          Icons.person,
                          '動物診断',
                          authController.diagnosis.value,
                          cardSize,
                        )),
                        const SizedBox(width: 24),
                        Obx(() {
                          double screenWidth = MediaQuery.of(context).size.width;
                          double photoCardSize = screenWidth * 0.42;
                          if (photoCardSize > 220.0) photoCardSize = 220.0;

                          return Container(
                            width: photoCardSize,
                            height: photoCardSize,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: GestureDetector(
                                onTap: () async {
                                  String animal = authController.diagnosis.value;

                                  final animalDoc = await FirebaseFirestore.instance
                                      .collection('animals')
                                      .where('animal', isEqualTo: animal)
                                      .get();

                                  if (animalDoc.docs.isNotEmpty) {
                                    var animalData = animalDoc.docs.first.data();

                                    String features = animalData['features'] ?? '特徴情報なし';
                                    String personality = animalData['personality'] ?? '性格情報なし';
                                    String relationships = animalData['relationships'] ?? '人間関係情報なし';

                                    final Map<String, List<String>> compatibilityMap = {
                                      'ねこさん': ['とりさん', 'へびさん', 'さるさん'],
                                      'はむさん': ['うしさん', 'ひつじさん', 'いぬさん'],
                                      'へびさん': ['とりさん', 'ねこさん', 'ひつじさん'],
                                      'ひつじさん': ['いぬさん', 'うしさん', 'はむさん'],
                                      'さるさん': ['とりさん', 'いぬさん', 'ねこさん'],
                                      'いぬさん': ['さるさん', 'ひつじさん', 'とりさん'],
                                      'とりさん': ['へびさん', 'さるさん', 'ねこさん'],
                                      'うしさん': ['ひつじさん', 'いぬさん', 'ねこさん'],
                                    };

                                    List<String> compatibleAnimals = compatibilityMap[animal] ?? [];

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          // title: const Text(
                                          //   "",
                                          // style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          // ),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "あなたの動物は「$animal」",
                                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 10),

                                                _buildAnimalRow([
                                                  _Animal(image: 'assets/images/$animal.png', label: 'あなた'),
                                                  ...compatibleAnimals.asMap().entries.map((entry) {
                                                    int rank = entry.key + 1;
                                                    String compatibleAnimal = entry.value;
                                                    return _Animal(
                                                      image: 'assets/images/$compatibleAnimal.png',
                                                      label: '$rank 位',
                                                    );
                                                  }).toList(),
                                                ]),
                                                const Divider(color: Colors.black),
                                                const SizedBox(height: 10),
                                                Text(
                                                  "特徴:\n$features",
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 18),
                                                Text(
                                                  "性格:\n$personality",
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 18),
                                                Text(
                                                  "人間関係:\n$relationships",
                                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
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
                                },
                                child: Image.asset(
                                  "assets/images/${authController.diagnosis.value}.png",
                                  width: photoCardSize,
                                  height: photoCardSize,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Obx(() => buildIntroductionCard(
                      context,
                      authController.introduction.value,
                    )),
                    const SizedBox(height: 24),
                    Obx(() => buildTagsSection(context, authController.tags)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimalRow(List<_Animal> animals) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: animals
          .map(
            (animal) => Column(
          children: [
            Text(animal.label),
            const SizedBox(height: 5),
            Image.asset(animal.image, width: 50, height: 50),
          ],
        ),
      )
          .toList(),
    );
  }
}

class _Animal {
  final String image;
  final String label;

  const _Animal({required this.image, required this.label});
}

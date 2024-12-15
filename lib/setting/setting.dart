import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                    // 学校、性別、MBTIのカード
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
                          '学校',
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
                          'MBTI',
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
                              child: Image.asset(
                                "assets/images/${authController.diagnosis.value}.png",
                                width: photoCardSize,
                                height: photoCardSize,
                                fit: BoxFit.cover,
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
}
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:omg/auth_controller.dart';
import 'package:omg/comp/likeToList.dart';
import 'package:omg/utilities/constant.dart';
import 'package:omg/with/swipeAsyncNotifier.dart' as notifier;
import 'package:omg/with/swipeCard.dart' as card;

import '../comp/nopeList.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  late AppinioSwiperController _swiperController;
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _swiperController = AppinioSwiperController();
  }

  @override
  void dispose() {
    super.dispose();
    _swiperController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(notifier.swipeAsyncNotifierProvider);
    final swipeNotifier = ref.read(notifier.swipeAsyncNotifierProvider.notifier);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          title: const Text('Hello World', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.elliptical(90, 30),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                int currentUserId = await loggedInUserId();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NopeList(currentUserId: currentUserId),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () async {
                int currentUserId = await loggedInUserId();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LikeToList(currentUserId: currentUserId),
                  ),
                );
              },
            ),
          ],
          backgroundColor: kAppBarBackground,
          elevation: 0,
        ),
        body: SafeArea(
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
              // カードの部分
              Align(
                alignment: Alignment.topCenter,
                child: asyncValue.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, _) => const Center(
                    child: Text("Error"),
                  ),
                  data: (data) {
                    return Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: MediaQuery.of(context).size.height * 0.85,
                        child: card.SwipeCard(
                          list: data,
                          onSwiping: (direction) async {
                            await swipeNotifier.swipeOnCard(direction);
                          },
                          controller: _swiperController,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> loggedInUserId() async {
    try {
      int loggedInUserId = authController.userId.value ?? 0;
      print(loggedInUserId);
      return loggedInUserId;
    } catch (e) {
      print(e);
      return 0;
    }
  }
}
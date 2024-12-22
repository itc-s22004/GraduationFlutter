import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:omg/auth_controller.dart';
import 'package:omg/comp/likeToList.dart';
import 'package:omg/comp/tooltip.dart';
import 'package:omg/utilities/constant.dart';
import 'package:omg/with/swipeAsyncNotifier.dart' as notifier;
import 'package:omg/with/swipeCard.dart' as card;

import '../comp/nopeList.dart';
import '../login/loginNext.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  late AppinioSwiperController _swiperController;
  final AuthController authController = Get.find<AuthController>();
  bool _showSlideText = false;

  @override
  void initState() {
    super.initState();
    _swiperController = AppinioSwiperController();

    ever(authController.swipedUserId, (swipedUserId) async {
      if (swipedUserId > 0) {
        await Future.delayed(const Duration(seconds: 1)); // スワイプされた２秒後に_checkMatchingを実行
        _checkMatching(swipedUserId);
      }
    });
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(notifier.swipeAsyncNotifierProvider);
    final swipeNotifier = ref.read(notifier.swipeAsyncNotifierProvider.notifier);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'スワイプ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
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
            const TooltipButton(tooltip: "相性を見る")
          ],
          backgroundColor: kAppBarBackground,
          elevation: 0,
        ),
        body: SafeArea(
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
              if (_showSlideText)
                Align(
                  alignment: Alignment.center,
                  child: SlideInText(
                    duration: const Duration(seconds: 1),
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
      return loggedInUserId;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  Future<void> _checkMatching(int swipedUserId) async {
    print("_checkMatchingだよーー");
    try {
      int currentUserId = await loggedInUserId();
      print("Current User ID: $currentUserId");

      var matchesCollection = FirebaseFirestore.instance.collection('matches');
      var querySnapshot = await matchesCollection
          .where('user1', isEqualTo: currentUserId)
          .where('user2', isEqualTo: swipedUserId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("Match found!");
        setState(() {
          _showSlideText = true;
        });

        Future.delayed(const Duration(seconds: 4), () {
          setState(() {
            _showSlideText = false;
          });
        });

      } else {
        print("No match found.");
      }
    } catch (e) {
      print("Error checking matching: $e");
    }
  }
}

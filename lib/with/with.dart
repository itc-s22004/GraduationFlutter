import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:omg/auth_controller.dart';
import 'package:omg/comp/likeToList.dart';
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
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Swipe'),
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
        ),
        body: SafeArea(
          child: asyncValue.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, _) => const Center(
              child: Text("Error"),
            ),
            data: (data) {
              return card.SwipeCard(
                list: data,
                onSwiping: (direction) async {
                  await swipeNotifier.swipeOnCard(direction);
                },
                controller: _swiperController,
              );
            },
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
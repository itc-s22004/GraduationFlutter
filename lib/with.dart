import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omg/with/swipeAsyncNotifier.dart' as notifier;
import 'package:omg/with/swipeCard.dart' as card;

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  late AppinioSwiperController _swiperController;

  @override
  void initState() {
    super.initState();
    // コントローラーの初期化
    _swiperController = AppinioSwiperController();
  }

  @override
  void dispose() {
    super.dispose();
    // コントローラーの破棄
    _swiperController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Userデータの取得
    final asyncValue = ref.watch(notifier.swipeAsyncNotifierProvider);
    // ViewModelの取得
    final swipeNotifier = ref.read(notifier.swipeAsyncNotifierProvider.notifier);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: asyncValue.when(
            // ローディング中の処理
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            // データ時の処理
            error: (error, _) => const Center(
              child: Text("Error"),
            ),
            // データ取得後の処理
            data: (data) {
              // カードウィジェットの表示
              return card.SwipeCard(
                list: data,
                onSwiping: (index, direction) async {
                  await swipeNotifier.swipeOnCard(direction as notifier.AppinioSwiperDirection);
                },
                controller: _swiperController, // スワイプ制御
              );
            },
          ),
        ),
      ),
    );
  }
}
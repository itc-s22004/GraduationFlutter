import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Next extends StatelessWidget {
  const Next({super.key});

    Future<int> getUserCount() async {
      try {
        final snapshot = await FirebaseFirestore.instance.collection('users').get();
        return snapshot.size;
      } catch (e) {
        print("Error fetching document count: $e");
        return 0;
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("next data"),
              FutureBuilder<int>(
                  future: getUserCount(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();  // ローディング中のインジケータ
                    } else if (snapshot.hasError) {
                      return const Text('Error fetching user count');
                    } else {
                      // 正常に取得できた場合、ユーザー数を表示
                      final userCount = snapshot.data ?? 0;
                      return Text('User Count: $userCount');
                    }
                  }
              )
            ],
            // mainAxisAlignment: MainAxisAlignment.center,
            // children: [
            //   Text('next page'),
            // ],
          )
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:omg/utilities/constant.dart';

Widget buildInfoCard(BuildContext context, IconData icon, String label, String value, double size) {
  double screenWidth = MediaQuery.of(context).size.width;
  double cardSize = (screenWidth * 0.42).clamp(0, size);

  return Container(
    width: cardSize,
    height: cardSize,
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: kObjectBackground,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          spreadRadius: 2,
          blurRadius: 8,
          offset: const Offset(2, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.green[700], size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: cardSize * 0.3,
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildTagsSection(BuildContext context, List<String> tags) {
  double screenWidth = MediaQuery.of(context).size.width;
  double cardWidth = (screenWidth * 0.9).clamp(0, 460);

  return Center(
    child: Container(
      width: cardWidth, // 計算された幅を使用
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.label, color: Colors.green),
              SizedBox(width: 8),
              Text(
                'タグ:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            runSpacing: 8.0,
            children: tags
                .map((tag) => Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: kObjectBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ))
                .toList(),
          ),
        ],
      ),
    ),
  );
}

Widget buildIntroductionCard(BuildContext context, String introduction) {
  double screenWidth = MediaQuery.of(context).size.width;
  double cardWidth = screenWidth * 0.9;
  cardWidth = cardWidth.clamp(0, 460);

  return Center(
    child: Container(
      width: cardWidth, // 画面幅の80%に設定
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: kObjectBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '自己紹介',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            introduction.isNotEmpty
                ? introduction
                : 'まだ自己紹介がありません。',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
  );
}

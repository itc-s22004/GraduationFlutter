// import 'package:appinio_swiper/appinio_swiper.dart';
// import 'package:flutter/cupertino.dart';
//
// class Test extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       child: SizedBox(
//         height: MediaQuery
//             .of(context)
//             .size
//             .height * 0.75,
//         child: AppinioSwiper(
//           cardsCount: 10,
//           onSwiping: (AppinioSwiperDirection direction) {
//             print(direction.toString());
//           },
//           cardsBuilder: (BuildContext context, int index) {
//             return Container(
//               alignment: Alignment.center,
//               child: const Text(index.toString()),
//               color: CupertinoColors.activeBlue,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
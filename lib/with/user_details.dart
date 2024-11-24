// import 'package:flutter/material.dart';
// import 'user.dart';
//
// class UserDetailsPanel extends StatelessWidget {
//   final User user;
//
//   const UserDetailsPanel({super.key, required this.user});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'User Details',
//             style: Theme.of(context).textTheme.titleLarge,
//           ),
//           const SizedBox(height: 16),
//           Text('Name: ${user.name}'),
//           const SizedBox(height: 16),
//           const Text('Tags:'),
//           Wrap(
//             spacing: 8.0,
//             children: user.tags.map((tag) => Chip(label: Text(tag))).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }
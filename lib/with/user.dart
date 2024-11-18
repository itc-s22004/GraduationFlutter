// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'user.freezed.dart';
//
// @freezed
// class User with _$User {
//   const factory User({
//     @Default([]) List<String> profileImageURL,
//     @Default("") String name,
//     required int userId,
//     @Default("") String mbti,
//     @Default([]) List<String> tags,
//   }) = _User;
//
//   const User._();
// }

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    @Default([]) List<String> profileImageURL,
    @Default("") String name,
    required int userId,
    @Default("") String mbti,
    @Default([]) List<String> tags,
    @Default("") String school,
    @Default("") String introduction,
  }) = _User;

  const User._();

  // fromMapメソッドを追加
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'] ?? 0,
      name: map['name'] ?? '',
      mbti: map['mbti'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      profileImageURL: List<String>.from(map['profileImageURL'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'mbti': mbti,
      'tags': tags,
      'profileImageURL': profileImageURL,
    };
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    @Default([]) List<String> profileImageURL,
    @Default("") String name,
    required int userId,
    @Default([]) List<String> tags,
  }) = _User;

  const User._();
}

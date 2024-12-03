// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$User {
  List<String> get profileImageURL => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  String get mbti => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String get school => throw _privateConstructorUsedError;
  String get introduction => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {List<String> profileImageURL,
      String name,
      int userId,
      String mbti,
      List<String> tags,
      String school,
      String introduction,
      String gender});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileImageURL = null,
    Object? name = null,
    Object? userId = null,
    Object? mbti = null,
    Object? tags = null,
    Object? school = null,
    Object? introduction = null,
    Object? gender = null,
  }) {
    return _then(_value.copyWith(
      profileImageURL: null == profileImageURL
          ? _value.profileImageURL
          : profileImageURL // ignore: cast_nullable_to_non_nullable
              as List<String>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      mbti: null == mbti
          ? _value.mbti
          : mbti // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      school: null == school
          ? _value.school
          : school // ignore: cast_nullable_to_non_nullable
              as String,
      introduction: null == introduction
          ? _value.introduction
          : introduction // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> profileImageURL,
      String name,
      int userId,
      String mbti,
      List<String> tags,
      String school,
      String introduction,
      String gender});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profileImageURL = null,
    Object? name = null,
    Object? userId = null,
    Object? mbti = null,
    Object? tags = null,
    Object? school = null,
    Object? introduction = null,
    Object? gender = null,
  }) {
    return _then(_$UserImpl(
      profileImageURL: null == profileImageURL
          ? _value._profileImageURL
          : profileImageURL // ignore: cast_nullable_to_non_nullable
              as List<String>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      mbti: null == mbti
          ? _value.mbti
          : mbti // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      school: null == school
          ? _value.school
          : school // ignore: cast_nullable_to_non_nullable
              as String,
      introduction: null == introduction
          ? _value.introduction
          : introduction // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UserImpl extends _User {
  const _$UserImpl(
      {final List<String> profileImageURL = const [],
      this.name = "",
      required this.userId,
      this.mbti = "",
      final List<String> tags = const [],
      this.school = "",
      this.introduction = "",
      this.gender = ""})
      : _profileImageURL = profileImageURL,
        _tags = tags,
        super._();

  final List<String> _profileImageURL;
  @override
  @JsonKey()
  List<String> get profileImageURL {
    if (_profileImageURL is EqualUnmodifiableListView) return _profileImageURL;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_profileImageURL);
  }

  @override
  @JsonKey()
  final String name;
  @override
  final int userId;
  @override
  @JsonKey()
  final String mbti;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final String school;
  @override
  @JsonKey()
  final String introduction;
  @override
  @JsonKey()
  final String gender;

  @override
  String toString() {
    return 'User(profileImageURL: $profileImageURL, name: $name, userId: $userId, mbti: $mbti, tags: $tags, school: $school, introduction: $introduction, gender: $gender)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            const DeepCollectionEquality()
                .equals(other._profileImageURL, _profileImageURL) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.mbti, mbti) || other.mbti == mbti) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.school, school) || other.school == school) &&
            (identical(other.introduction, introduction) ||
                other.introduction == introduction) &&
            (identical(other.gender, gender) || other.gender == gender));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_profileImageURL),
      name,
      userId,
      mbti,
      const DeepCollectionEquality().hash(_tags),
      school,
      introduction,
      gender);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);
}

abstract class _User extends User {
  const factory _User(
      {final List<String> profileImageURL,
      final String name,
      required final int userId,
      final String mbti,
      final List<String> tags,
      final String school,
      final String introduction,
      final String gender}) = _$UserImpl;
  const _User._() : super._();

  @override
  List<String> get profileImageURL;
  @override
  String get name;
  @override
  int get userId;
  @override
  String get mbti;
  @override
  List<String> get tags;
  @override
  String get school;
  @override
  String get introduction;
  @override
  String get gender;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

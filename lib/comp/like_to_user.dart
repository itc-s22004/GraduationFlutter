class LikeToUser {
  final String name;
  final int userId;
  final String likeDocId;
  final String gender;
  final String introduction;
  final String mbti;
  final String school;
  final List<String> tags;

  LikeToUser({
    required this.name,
    required this.userId,
    required this.likeDocId,
    required this.gender,
    required this.introduction,
    required this.mbti,
    required this.school,
    required this.tags,
  });

  factory LikeToUser.fromMap(Map<String, dynamic> data) {
    return LikeToUser(
      name: data['name'] as String,
      userId: data['userId'] as int,
      likeDocId: data['likeDocId'] as String,
      gender: data['gender'] as String,
      introduction: data['introduction'] as String,
      mbti: data['mbti'] as String,
      school: data['school'] as String,
      tags: List<String>.from(data['tags'] ?? []),
    );
  }
}


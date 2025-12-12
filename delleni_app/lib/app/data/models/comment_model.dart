class CommentModel {
  final String id;
  final String serviceId;
  final String username;
  final String content;
  final int likes;
  final DateTime? createdAt;

  CommentModel({
    required this.id,
    required this.serviceId,
    required this.username,
    required this.content,
    required this.likes,
    this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id']?.toString() ?? '',
      serviceId: map['service_id']?.toString() ?? '',
      username: map['username']?.toString() ?? 'مستخدم',
      content: map['content']?.toString() ?? '',
      likes: (map['likes'] as int?) ?? 0,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'service_id': serviceId,
      'username': username,
      'content': content,
      'likes': likes,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toMapForInsert() {
    return {
      'service_id': serviceId,
      'username': username,
      'content': content,
      'likes': likes,
    };
  }

  CommentModel copyWith({
    String? id,
    String? serviceId,
    String? username,
    String? content,
    int? likes,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      username: username ?? this.username,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  CommentModel incrementLikes() {
    return copyWith(likes: likes + 1);
  }
}

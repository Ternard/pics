class PhotoWidget {
  final String id;
  final String imageUrl;
  final String uploadedBy;
  final String uploadedById;
  final DateTime createdAt;
  final List<String> likedBy;
  final List<Comment> comments;
  final List<String> sharedWith; // Friend IDs

  PhotoWidget({
    required this.id,
    required this.imageUrl,
    required this.uploadedBy,
    required this.uploadedById,
    required this.createdAt,
    this.likedBy = const [],
    this.comments = const [],
    this.sharedWith = const [],
  });

  factory PhotoWidget.fromJson(Map<String, dynamic> json) {
    return PhotoWidget(
      id: json['id'] ?? '',
      imageUrl: json['image_url'] ?? '',
      uploadedBy: json['uploaded_by'] ?? '',
      uploadedById: json['uploaded_by_id'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      likedBy: json['liked_by'] != null ? List<String>.from(json['liked_by']) : [],
      comments: json['comments'] != null
          ? (json['comments'] as List).map((c) => Comment.fromJson(c)).toList()
          : [],
      sharedWith: json['shared_with'] != null ? List<String>.from(json['shared_with']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'uploaded_by': uploadedBy,
      'uploaded_by_id': uploadedById,
      'created_at': createdAt.toIso8601String(),
      'liked_by': likedBy,
      'comments': comments.map((c) => c.toJson()).toList(),
      'shared_with': sharedWith,
    };
  }
}

class Comment {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      text: json['text'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'text': text,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
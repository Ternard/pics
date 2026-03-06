class NotificationModel {
  final String id;
  final String type; // 'like', 'comment', 'share', 'add_to_widget'
  final String userId;
  final String userName;
  final String? userAvatar;
  final String? photoId;
  final String? photoUrl;
  final String? commentText;
  final DateTime createdAt;
  bool isRead; // Changed from final to non-final

  NotificationModel({
    required this.id,
    required this.type,
    required this.userId,
    required this.userName,
    this.userAvatar,
    this.photoId,
    this.photoUrl,
    this.commentText,
    required this.createdAt,
    this.isRead = false, // Now can be changed
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userAvatar: json['user_avatar'],
      photoId: json['photo_id'],
      photoUrl: json['photo_url'],
      commentText: json['comment_text'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'photo_id': photoId,
      'photo_url': photoUrl,
      'comment_text': commentText,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
    };
  }

  // Create a copy of the notification with updated fields
  NotificationModel copyWith({
    String? id,
    String? type,
    String? userId,
    String? userName,
    String? userAvatar,
    String? photoId,
    String? photoUrl,
    String? commentText,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      photoId: photoId ?? this.photoId,
      photoUrl: photoUrl ?? this.photoUrl,
      commentText: commentText ?? this.commentText,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
class Friend {
  final String id;
  final String name;
  final String? avatarUrl;
  final bool isOnline;
  final String? lastActive;
  final List<String>? sharedWidgets;

  Friend({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.isOnline = false,
    this.lastActive,
    this.sharedWidgets,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatar_url'],
      isOnline: json['is_online'] ?? false,
      lastActive: json['last_active'],
      sharedWidgets: json['shared_widgets'] != null
          ? List<String>.from(json['shared_widgets'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
      'is_online': isOnline,
      'last_active': lastActive,
      'shared_widgets': sharedWidgets,
    };
  }
}
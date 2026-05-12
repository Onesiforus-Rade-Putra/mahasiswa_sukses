class FriendModel {
  final String id;
  final String username;
  final String fullName;
  final int level;
  final int totalXp;
  final bool onlineStatus;

  const FriendModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.level,
    required this.totalXp,
    required this.onlineStatus,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: json['id']?.toString() ?? '',
      username:
          json['username']?.toString() ?? json['user_name']?.toString() ?? '',
      fullName:
          json['full_name']?.toString() ?? json['fullname']?.toString() ?? '',
      level: _toInt(json['level']),
      totalXp: _toInt(json['total_xp'] ?? json['totalxp']),
      onlineStatus: json['online_status'] == true,
    );
  }

  String get displayName {
    if (fullName.trim().isNotEmpty) return fullName;
    if (username.trim().isNotEmpty) return username;
    return 'Teman';
  }

  String get avatarText {
    final name = displayName.trim();

    if (name.isEmpty) return '?';

    final parts = name.split(' ').where((e) => e.isNotEmpty).toList();

    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    return name[0].toUpperCase();
  }
}

class FriendSummaryModel {
  final int friendCount;
  final int friendRequestCount;

  const FriendSummaryModel({
    required this.friendCount,
    required this.friendRequestCount,
  });

  const FriendSummaryModel.empty()
      : friendCount = 0,
        friendRequestCount = 0;

  factory FriendSummaryModel.fromJson(Map<String, dynamic> json) {
    return FriendSummaryModel(
      friendCount: _toInt(json['friend_count']),
      friendRequestCount: _toInt(json['friend_request_count']),
    );
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();

  return int.tryParse(value.toString()) ?? 0;
}

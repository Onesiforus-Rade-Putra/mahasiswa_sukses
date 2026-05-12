class UserProfileModel {
  final String id;
  final String email;
  final String? username;
  final String? fullName;
  final String? description;
  final String? phoneNumber;
  final String? nim;
  final String? birthDate;
  final bool notifications;
  final bool shareLeaderboardStats;
  final int totalXp;
  final int currentLevel;

  UserProfileModel({
    required this.id,
    required this.email,
    this.username,
    this.fullName,
    this.description,
    this.phoneNumber,
    this.nim,
    this.birthDate,
    required this.notifications,
    required this.shareLeaderboardStats,
    required this.totalXp,
    required this.currentLevel,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      username: json['username']?.toString() ?? json['user_name']?.toString(),
      fullName: json['full_name']?.toString(),
      description: json['description']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      nim: json['nim']?.toString(),
      birthDate: json['birth_date']?.toString(),
      notifications:
          json['notifications'] == true || json['notification_on'] == true,
      shareLeaderboardStats: json['share_leaderboard_stats'] == true,
      totalXp: _toInt(json['total_xp'] ?? json['totalxp']),
      currentLevel: _toInt(json['current_level'] ?? json['level']),
    );
  }

  String get displayName {
    if (fullName != null && fullName!.trim().isNotEmpty) {
      return fullName!;
    }

    if (username != null && username!.trim().isNotEmpty) {
      return username!;
    }

    return 'Mahasiswa';
  }

  String get displayUsername {
    if (username != null && username!.trim().isNotEmpty) {
      return username!;
    }

    if (email.trim().isNotEmpty) {
      return email.split('@').first;
    }

    return 'username';
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();

  return int.tryParse(value.toString()) ?? 0;
}

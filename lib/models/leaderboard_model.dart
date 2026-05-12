class LeaderboardModel {
  final int rank;
  final String name;
  final String initials;
  final int point;
  final int level;

  LeaderboardModel({
    required this.rank,
    required this.name,
    required this.initials,
    required this.point,
    required this.level,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};

    final fullName =
        (user['full_name'] ?? user['username'] ?? 'Pengguna').toString().trim();

    return LeaderboardModel(
      rank: _toInt(json['rank']),
      name: fullName,
      initials: _generateInitials(fullName),
      point: _toInt(json['xp']),
      level: _toInt(json['level']),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _generateInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || name.trim().isEmpty) {
      return 'U';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

class LeaderboardResponse {
  final int userRank;
  final int userTotalXp;
  final List<LeaderboardModel> topGlobal;
  final List<LeaderboardModel> topFriends;

  LeaderboardResponse({
    required this.userRank,
    required this.userTotalXp,
    required this.topGlobal,
    required this.topFriends,
  });

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final topGlobalJson = data['top_global'] as List<dynamic>? ?? [];
    final topFriendsJson = data['top_friends'] as List<dynamic>? ?? [];

    return LeaderboardResponse(
      userRank: LeaderboardModel._toInt(data['user_rank']),
      userTotalXp: LeaderboardModel._toInt(data['user_total_xp']),
      topGlobal:
          topGlobalJson.map((item) => LeaderboardModel.fromJson(item)).toList(),
      topFriends: topFriendsJson
          .map((item) => LeaderboardModel.fromJson(item))
          .toList(),
    );
  }
}

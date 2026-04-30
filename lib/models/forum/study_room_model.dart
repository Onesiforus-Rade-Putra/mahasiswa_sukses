class StudyRoomModel {
  final int id;
  final String authorName;
  final String authorInitial;
  final String title;
  final String description;
  final int currentParticipants;
  final int maxParticipants;
  final int likes;
  final String timeAgo;
  final bool isJoined;
  final bool isActive;
  final bool isLiked;

  StudyRoomModel({
    required this.id,
    required this.authorName,
    required this.authorInitial,
    required this.title,
    required this.description,
    required this.currentParticipants,
    required this.maxParticipants,
    required this.likes,
    required this.timeAgo,
    this.isJoined = false,
    this.isActive = true,
    this.isLiked = false,
  });

  factory StudyRoomModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;

    final fullName = author?['full_name']?.toString() ?? 'User';

    return StudyRoomModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      authorName: fullName,
      authorInitial: _getInitial(fullName),
      title: json['title']?.toString() ?? '-',
      description: json['description']?.toString() ?? '',
      currentParticipants: json['current_participants'] is int
          ? json['current_participants']
          : 0,
      maxParticipants:
          json['max_participants'] is int ? json['max_participants'] : 20,
      likes: json['likes_count'] is int ? json['likes_count'] : 0,
      timeAgo: _formatTimeAgo(json['created_at']?.toString()),
      isJoined: json['is_joined'] == true,
      isActive: json['is_active'] != false,
      isLiked: json['is_liked'] == true,
    );
  }

  static String _getInitial(String name) {
    final words = name.trim().split(' ');

    if (words.isEmpty || words.first.isEmpty) {
      return 'US';
    }

    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }

    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  static String _formatTimeAgo(String? value) {
    if (value == null) return 'Baru saja';

    final createdAt = DateTime.tryParse(value);
    if (createdAt == null) return 'Baru saja';

    final diff = DateTime.now().difference(createdAt);

    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';

    return '${diff.inDays} hari lalu';
  }
}

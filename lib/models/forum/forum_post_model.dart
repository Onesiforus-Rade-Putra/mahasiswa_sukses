class ForumPostModel {
  final int id;
  final String authorName;
  final String authorInitial;
  final String category;
  final String title;
  final String description;
  final List<String> tags;
  final int likes;
  final int comments;
  final String timeAgo;
  final bool isLiked;

  ForumPostModel({
    required this.id,
    required this.authorName,
    required this.authorInitial,
    required this.category,
    required this.title,
    required this.description,
    required this.tags,
    required this.likes,
    required this.comments,
    required this.timeAgo,
    this.isLiked = false,
  });

  factory ForumPostModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;

    final fullName = author?['full_name']?.toString() ?? 'User';

    return ForumPostModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      authorName: fullName,
      authorInitial: _getInitial(fullName),
      category: _mapCategoryFromApi(json['category']?.toString() ?? 'umum'),
      title: json['title']?.toString() ?? '-',
      description: json['content']?.toString() ?? '',
      tags: (json['tags'] is List)
          ? List<String>.from(json['tags'].map((tag) => tag.toString()))
          : [],
      likes: json['likes_count'] is int ? json['likes_count'] : 0,
      comments: json['comments_count'] is int ? json['comments_count'] : 0,
      timeAgo: _formatTimeAgo(json['created_at']?.toString()),
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

  static String _mapCategoryFromApi(String category) {
    switch (category) {
      case 'umum':
        return 'Umum';
      case 'tips_trik':
        return 'Tips & Trik';
      case 'bantuan':
        return 'Bantuan';
      default:
        return 'Umum';
    }
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

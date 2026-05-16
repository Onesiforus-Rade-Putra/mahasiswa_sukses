class ForumCommentModel {
  final int id;
  final String authorId;
  final String authorName;
  final String authorUsername;
  final String authorInitial;
  final String comment;
  final String time;

  ForumCommentModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorUsername,
    required this.authorInitial,
    required this.comment,
    required this.time,
  });

  factory ForumCommentModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] is Map<String, dynamic>
        ? json['author'] as Map<String, dynamic>
        : <String, dynamic>{};

    final fullName = author['full_name']?.toString() ?? 'User';
    final username = author['username']?.toString() ?? '';

    return ForumCommentModel(
      id: _toInt(json['id']),
      authorId: author['id']?.toString() ?? '',
      authorName: fullName,
      authorUsername: username,
      authorInitial: _getInitial(fullName.isNotEmpty ? fullName : username),
      comment: json['comment']?.toString() ?? '',
      time: _formatTime(json['created_at']?.toString()),
    );
  }

  static int _toInt(dynamic value, {int defaultValue = 0}) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? defaultValue;
  }

  static String _getInitial(String name) {
    final cleanName = name.trim();

    if (cleanName.isEmpty) return 'U';

    final words = cleanName.split(' ');

    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }

    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  static String _formatTime(String? value) {
    if (value == null) return '';

    final date = DateTime.tryParse(value);
    if (date == null) return '';

    final localDate = date.toLocal();

    final hour = localDate.hour.toString().padLeft(2, '0');
    final minute = localDate.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}

class ChatMessageModel {
  final int id;
  final String senderName;
  final String senderInitial;
  final String message;
  final String time;
  final bool isMe;
  final bool isAdmin;
  final bool isLiked;
  final int likes;
  final int replies;

  final String authorId;
  final String authorUsername;
  final String authorFullName;

  ChatMessageModel({
    required this.id,
    required this.senderName,
    required this.senderInitial,
    required this.message,
    required this.time,
    required this.isMe,
    required this.authorId,
    required this.authorUsername,
    required this.authorFullName,
    this.isAdmin = false,
    this.isLiked = false,
    this.likes = 0,
    this.replies = 0,
  });

  factory ChatMessageModel.fromJson(
    Map<String, dynamic> json, {
    String? currentUsername,
    String? currentUserId,
  }) {
    final author = json['author'] is Map<String, dynamic>
        ? json['author'] as Map<String, dynamic>
        : <String, dynamic>{};

    final authorId = author['id']?.toString() ?? '';
    final authorUsername = author['username']?.toString() ?? '';
    final authorFullName = author['full_name']?.toString() ?? 'User';

    final cleanCurrentUsername = currentUsername?.toLowerCase().trim() ?? '';
    final cleanCurrentUserId = currentUserId?.trim() ?? '';

    final isMineById = cleanCurrentUserId.isNotEmpty &&
        authorId.isNotEmpty &&
        authorId == cleanCurrentUserId;

    final isMineByUsername = cleanCurrentUsername.isNotEmpty &&
        authorUsername.toLowerCase().trim() == cleanCurrentUsername;

    final isMineByFullName = cleanCurrentUsername.isNotEmpty &&
        authorFullName.toLowerCase().trim() == cleanCurrentUsername;

    return ChatMessageModel(
      id: _toInt(json['id']),
      senderName: authorFullName,
      senderInitial: _getInitial(authorFullName),
      message: _readMessageText(json),
      time: _formatTime(json['created_at']?.toString()),
      isMe: json['is_me'] == true ||
          isMineById ||
          isMineByUsername ||
          isMineByFullName,
      isAdmin: json['is_admin'] == true,
      isLiked: json['is_liked'] == true,
      likes: _toInt(json['likes_count']),
      replies: _toInt(json['reply_count'] ?? json['replies_count']),
      authorId: authorId,
      authorUsername: authorUsername,
      authorFullName: authorFullName,
    );
  }

  static int _toInt(dynamic value, {int defaultValue = 0}) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? defaultValue;
  }

  static String _readMessageText(Map<String, dynamic> json) {
    final content = json['content']?.toString().trim();
    if (content != null && content.isNotEmpty) return content;

    final message = json['message']?.toString().trim();
    if (message != null && message.isNotEmpty) return message;

    final comment = json['comment']?.toString().trim();
    if (comment != null && comment.isNotEmpty) return comment;

    return '';
  }

  static String _getInitial(String name) {
    final words = name.trim().split(' ');

    if (words.isEmpty || words.first.isEmpty) {
      return 'U';
    }

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

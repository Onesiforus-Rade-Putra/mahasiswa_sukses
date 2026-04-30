class ChatMessageModel {
  final int id;
  final String senderName;
  final String senderInitial;
  final String message;
  final String time;
  final bool isMe;
  final bool isAdmin;
  final int likes;
  final int replies;

  ChatMessageModel({
    required this.id,
    required this.senderName,
    required this.senderInitial,
    required this.message,
    required this.time,
    required this.isMe,
    this.isAdmin = false,
    this.likes = 0,
    this.replies = 0,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    final fullName = author?['full_name']?.toString() ?? 'User';

    final content = _readMessageText(json);

    return ChatMessageModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      senderName: fullName,
      senderInitial: _getInitial(fullName),
      message: content,
      time: _formatTime(json['created_at']?.toString()),

      // sementara pakai nama login kamu agar chat sendiri muncul kanan
      isMe: json['is_me'] == true ||
          fullName.toLowerCase().trim() == 'putra' ||
          fullName.toLowerCase().trim() == 'athallah',

      isAdmin: json['is_admin'] == true,
      likes: json['likes_count'] is int ? json['likes_count'] : 0,
      replies: json['replies_count'] is int ? json['replies_count'] : 0,
    );
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
      return 'US';
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

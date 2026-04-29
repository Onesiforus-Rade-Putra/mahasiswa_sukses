class ChatMessageModel {
  final String id;
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
}

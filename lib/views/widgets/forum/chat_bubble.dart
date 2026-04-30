import 'package:flutter/material.dart';

import '../../../models/forum/chat_message_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isMe) {
      return _MyChatBubble(message: message);
    }

    return _OtherChatBubble(message: message);
  }
}

class _OtherChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const _OtherChatBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final avatarColor = message.senderInitial == 'SA'
        ? const Color(0xFF2F80ED)
        : const Color(0xFFFF1D35);

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: avatarColor,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              message.senderInitial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      message.senderName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF222222),
                      ),
                    ),
                    if (message.isAdmin) ...[
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF1D35),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Admin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(width: 8),
                    Text(
                      message.time,
                      style: const TextStyle(
                        color: Color(0xFF777777),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 220,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    message.message,
                    style: const TextStyle(
                      color: Color(0xFF222222),
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(
                      Icons.thumb_up_alt_outlined,
                      size: 14,
                      color: Color(0xFF9A9A9A),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${message.likes}',
                      style: const TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 10,
                      ),
                    ),
                    if (message.replies > 0) ...[
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.reply,
                        size: 14,
                        color: Color(0xFF9A9A9A),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${message.replies} balasan',
                        style: const TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MyChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const _MyChatBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4, bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  message.time,
                  style: const TextStyle(
                    color: Color(0xFF777777),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Anda',
                  style: TextStyle(
                    color: Color(0xFFFF1D35),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            constraints: const BoxConstraints(
              maxWidth: 260,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 11,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFFF1D35),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Text(
              message.message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

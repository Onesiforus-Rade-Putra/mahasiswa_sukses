import 'package:flutter/material.dart';

import '../../../models/forum/chat_message_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool? isMine;
  final VoidCallback? onLikeTap;

  const ChatBubble({
    super.key,
    required this.message,
    this.isMine,
    this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    final mine = isMine ?? message.isMe;

    final bubbleColor = mine ? const Color(0xFFF91D2F) : Colors.white;
    final textColor = mine ? Colors.white : const Color(0xFF222222);
    final likeColor =
        message.isLiked ? const Color(0xFFF91D2F) : Colors.grey.shade500;

    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        mainAxisAlignment:
            mine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!mine) ...[
            _Avatar(initial: message.senderInitial),
            const SizedBox(width: 14),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!mine) ...[
                      Text(
                        message.senderName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      message.time,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8F8F8F),
                      ),
                    ),
                    if (mine) ...[
                      const SizedBox(width: 8),
                      const Text(
                        'Anda',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF91D2F),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  constraints: const BoxConstraints(maxWidth: 245),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(mine ? 16 : 4),
                      bottomRight: Radius.circular(mine ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: onLikeTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          message.isLiked
                              ? Icons.thumb_up_alt
                              : Icons.thumb_up_alt_outlined,
                          size: 16,
                          color: likeColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${message.likes}',
                          style: TextStyle(
                            fontSize: 11,
                            color: likeColor,
                            fontWeight: message.isLiked
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (mine) ...[
            const SizedBox(width: 14),
            _Avatar(initial: message.senderInitial),
          ],
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initial;

  const _Avatar({
    required this.initial,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFFF2838),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        initial.isNotEmpty ? initial : 'U',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
      ),
    );
  }
}

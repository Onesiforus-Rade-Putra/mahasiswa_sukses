import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/forum_viewmodel.dart';
import '../widgets/forum/chat_bubble.dart';

class StudyRoomChatPage extends StatelessWidget {
  final int roomId;
  final String roomTitle;

  const StudyRoomChatPage({
    super.key,
    required this.roomId,
    required this.roomTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForumViewModel()..initChatRoom(roomId),
      child: _StudyRoomChatPageContent(
        roomId: roomId,
        roomTitle: roomTitle,
      ),
    );
  }
}

class _StudyRoomChatPageContent extends StatelessWidget {
  final int roomId;
  final String roomTitle;

  const _StudyRoomChatPageContent({
    required this.roomId,
    required this.roomTitle,
  });

  @override
  Widget build(BuildContext context) {
    final forumVM = context.watch<ForumViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _ChatHeader(
              title: roomTitle,
              onBackTap: () => Navigator.pop(context),
            ),
            Expanded(
              child: forumVM.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFF91D2F),
                      ),
                    )
                  : forumVM.errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              forumVM.errorMessage!,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.builder(
                          reverse: true,
                          padding: const EdgeInsets.fromLTRB(23, 22, 23, 18),
                          itemCount: forumVM.chatMessages.length,
                          itemBuilder: (context, index) {
                            final message = forumVM.chatMessages[index];
                            return ChatBubble(message: message);
                          },
                        ),
            ),
            _ChatInputBar(
              roomId: roomId,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBackTap;

  const _ChatHeader({
    required this.title,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(29, 58, 29, 26),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFF1A2D),
            Color(0xFF9D111B),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBackTap,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.2),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Study Group: $title',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              height: 1.35,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const _HeaderBadge(
                icon: Icons.groups_outlined,
                label: '15 / 20 Peserta',
              ),
              const SizedBox(width: 8),
              Container(
                height: 29,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: Colors.white),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 4,
                      backgroundColor: Color(0xFF34C759),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Aktif',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 29,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 15,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatInputBar extends StatefulWidget {
  final int roomId;

  const _ChatInputBar({
    required this.roomId,
  });

  @override
  State<_ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<_ChatInputBar> {
  final TextEditingController messageController = TextEditingController();
  bool isSending = false;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = messageController.text.trim();

    if (text.isEmpty || isSending) return;

    setState(() {
      isSending = true;
    });

    final forumVM = context.read<ForumViewModel>();

    final success = await forumVM.sendMessage(
      roomId: widget.roomId,
      message: text,
    );

    if (!mounted) return;

    setState(() {
      isSending = false;
    });

    if (success) {
      messageController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            forumVM.errorMessage ?? 'Gagal mengirim pesan',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 73,
      padding: const EdgeInsets.fromLTRB(23, 9, 23, 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF91D2F),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sentiment_satisfied_alt,
              color: Color(0xFF8A8A8A),
              size: 21,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      minLines: 1,
                      maxLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Tulis pesan...',
                        hintStyle: TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.attach_file,
                    color: Color(0xFF777777),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: isSending
                  ? const Padding(
                      padding: EdgeInsets.all(11),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFFF91D2F),
                      ),
                    )
                  : const Icon(
                      Icons.send_outlined,
                      color: Color(0xFFF91D2F),
                      size: 22,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

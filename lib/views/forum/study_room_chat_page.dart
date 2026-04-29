import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/forum_viewmodel.dart';
import '../widgets/forum/chat_bubble.dart';

class StudyRoomChatPage extends StatelessWidget {
  const StudyRoomChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForumViewModel(),
      child: const _StudyRoomChatPageContent(),
    );
  }
}

class _StudyRoomChatPageContent extends StatelessWidget {
  const _StudyRoomChatPageContent();

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
              onBackTap: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(23, 22, 23, 18),
                itemCount: forumVM.chatMessages.length,
                itemBuilder: (context, index) {
                  final message = forumVM.chatMessages[index];
                  return ChatBubble(message: message);
                },
              ),
            ),
            const _ChatInputBar(),
          ],
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const _ChatHeader({
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
          const Text(
            'Study Group: Persiapan UTS\nAlgoritma',
            style: TextStyle(
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

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar();

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
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tulis pesan...',
                      style: TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.attach_file,
                    color: Color(0xFF777777),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.send_outlined,
              color: Color(0xFFF91D2F),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

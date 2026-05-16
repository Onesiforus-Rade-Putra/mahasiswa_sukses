import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/forum/forum_post_model.dart';
import '../../viewmodels/forum_viewmodel.dart';

class ForumPostDetailPage extends StatelessWidget {
  final ForumPostModel post;

  const ForumPostDetailPage({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForumViewModel()..fetchPostComments(post.id),
      child: _ForumPostDetailContent(post: post),
    );
  }
}

class _ForumPostDetailContent extends StatefulWidget {
  final ForumPostModel post;

  const _ForumPostDetailContent({
    required this.post,
  });

  @override
  State<_ForumPostDetailContent> createState() =>
      _ForumPostDetailContentState();
}

class _ForumPostDetailContentState extends State<_ForumPostDetailContent> {
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final forumVM = context.read<ForumViewModel>();

    final success = await forumVM.sendPostComment(
      postId: widget.post.id,
      comment: commentController.text,
    );

    if (!mounted) return;

    if (success) {
      commentController.clear();
      await forumVM.fetchPostComments(widget.post.id);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            forumVM.errorMessage ?? 'Gagal mengirim komentar',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final forumVM = context.watch<ForumViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(
              title: 'Detail Postingan',
              onBackTap: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 110),
                children: [
                  _PostDetailCard(post: widget.post),
                  const SizedBox(height: 20),
                  const Text(
                    'Komentar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (forumVM.isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFF91D2F),
                        ),
                      ),
                    )
                  else if (forumVM.postComments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: Center(
                        child: Text(
                          'Belum ada komentar',
                          style: TextStyle(
                            color: Color(0xFF777777),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                  else
                    ...forumVM.postComments.map((comment) {
                      return _CommentTile(
                        initial: comment.authorInitial,
                        name: comment.authorName,
                        time: comment.time,
                        comment: comment.comment,
                      );
                    }),
                ],
              ),
            ),
            _CommentInput(
              controller: commentController,
              isLoading: forumVM.isActionLoading,
              onSendTap: _sendComment,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final VoidCallback onBackTap;

  const _Header({
    required this.title,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 145,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 38, 28, 24),
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
      child: Row(
        children: [
          GestureDetector(
            onTap: onBackTap,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PostDetailCard extends StatelessWidget {
  final ForumPostModel post;

  const _PostDetailCard({
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE7E7E7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.13),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Avatar(initial: post.authorInitial),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.authorName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    post.timeAgo,
                    style: const TextStyle(
                      color: Color(0xFF777777),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            post.description,
            style: const TextStyle(
              color: Color(0xFF555555),
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: post.tags.map((tag) {
              return _Tag(label: '# $tag');
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final String initial;
  final String name;
  final String time;
  final String comment;

  const _CommentTile({
    required this.initial,
    required this.name,
    required this.time,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(initial: initial, size: 38),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  comment,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSendTap;

  const _CommentInput({
    required this.controller,
    required this.isLoading,
    required this.onSendTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        10,
        20,
        bottomPadding > 0 ? bottomPadding : 12,
      ),
      color: const Color(0xFFF91D2F),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(21),
              ),
              child: TextField(
                controller: controller,
                cursorColor: const Color(0xFFF91D2F),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSendTap(),
                decoration: const InputDecoration(
                  hintText: 'Tulis komentar...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: isLoading ? null : onSendTap,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: isLoading
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
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initial;
  final double size;

  const _Avatar({
    required this.initial,
    this.size = 42,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF91D2F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        initial,
        style: TextStyle(
          color: Colors.white,
          fontSize: size == 42 ? 17 : 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;

  const _Tag({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3F4),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFF91D2F)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFF91D2F),
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

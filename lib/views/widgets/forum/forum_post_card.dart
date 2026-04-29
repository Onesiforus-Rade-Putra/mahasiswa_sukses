import 'package:flutter/material.dart';
import '../../../models/forum/forum_post_model.dart';

class ForumPostCard extends StatelessWidget {
  final ForumPostModel post;

  const ForumPostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 14, 24, 6),
      padding: const EdgeInsets.fromLTRB(25, 18, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE7E7E7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(initial: post.authorInitial),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post.timeAgo,
                      style: const TextStyle(
                        color: Color(0xFF777777),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              _Tag(label: '# ${post.category}'),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              post.title,
              style: const TextStyle(
                fontSize: 12,
                height: 1.28,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 11),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              post.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF737373),
                fontSize: 10,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: post.tags.map((tag) {
                return _Tag(label: '# $tag');
              }).toList(),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.thumb_up_alt_outlined, size: 14),
              const SizedBox(width: 4),
              Text(
                '${post.likes}',
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 18),
              const Icon(Icons.chat_bubble_outline, size: 14),
              const SizedBox(width: 4),
              Text(
                '${post.comments} Komentar',
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 10,
                ),
              ),
            ],
          ),
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
      width: 39,
      height: 39,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF91D2F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
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
          fontSize: 9,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

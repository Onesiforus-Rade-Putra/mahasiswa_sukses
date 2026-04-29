import 'package:flutter/material.dart';

class ForumSegmentTab extends StatelessWidget {
  final bool isStudyRoom;
  final VoidCallback onPostTap;
  final VoidCallback onStudyRoomTap;

  const ForumSegmentTab({
    super.key,
    required this.isStudyRoom,
    required this.onPostTap,
    required this.onStudyRoomTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      margin: const EdgeInsets.symmetric(horizontal: 28),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: Colors.white, width: 1.1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentItem(
              label: 'Postingan',
              icon: Icons.chat_bubble_outline,
              isActive: !isStudyRoom,
              onTap: onPostTap,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _SegmentItem(
              label: 'Ruang Belajar',
              icon: Icons.menu_book_outlined,
              isActive: isStudyRoom,
              onTap: onStudyRoomTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _SegmentItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFFF91D2F);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: double.infinity,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: isActive ? activeColor : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeColor : Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
